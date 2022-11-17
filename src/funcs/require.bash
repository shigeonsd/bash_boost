#! /bin/bash
#
# require.sh -- 
#
#

function __require_file_1() {
    local file="${1}";
    "${___info}" " require ${file}. ";
    source "${file}";
    __bash_boost_required__+=( "${file}" );
    "${___info}" "done";
}

function __require_file_once() {
    local file="${1}";
    array_exists "${file}" __bash_boost_required__  && return 1;
    __require_file_1 "${file}";
    return 0;
}

function __require_file_force() {
    local file="${1}";
    __require_file_1 "${file}";
}

function __require_file() {
    local file="${1}";
    local paths="${2}";
    local suffixes=( ".bash" ".mod" ".class" ".sh" "" );
    local file;
    local fullpath;
    for path  in $(echo ${paths} | sed -e 's/:/ /g'); do
	for suffix in "${suffixes}"; do
	    fullpath="${path}/${file}${suffix}";
	    exist_file "${fullpath}" && {
		"__require_file_${___mode}" "${fullpath}";
		return $?;
	    }
	done
    done
    die "File not found. '${file}'";
    return 1;
}

function __invoke_init() {
    local init_func="_${___name}_init";
    exist_func "${init_func}" || return;
    "${___info}" "Initializing ${___name}... ";
    "${init_func}";
    "${___info}" "done";
}

function __add_cleanup() {
    local func="_${___name}_cleanup";
    exist_func "${func}" || return;
    __bash_boost_cleanup_funcs__+=( "${func}" );
}

function __require() {
    local file="$1";
    local ___name=$(echo $1 | sed -e 's/\.[^.]*$//');
    local require_path="${progdir}:${funcs_dir}:${extra_funcs_dir}:${class_dir}";
    exist_var BASHBOOSTPATH && {
	require_path="${BASHBOOSTPATH}:${require_path}";
    }
    __require_file "${file}" "${require_path}" && {
	__add_cleanup;
	__invoke_init;
    }
}

function require() {
    local ___mode="once";
    local bash_file;
    local ___info=":";
    for bash_file in "$@"; do
	case "${bash_file}" in 
	-f) ___mode="force"; continue; ;;
	-v) ___info="info";  continue; ;;
	 *) __require ${bash_file}; ;;
	esac
    done;
}

function __required_files() {
    local f;
    local n=0;
    echo "Required files are;";
    for f in "${__bash_boost_required__[@]}"; do
	echo "    ${f}";
	((n++));
    done;
    echo "${n} file(s).";
}

function __on_exit() {
    for f in "${__bash_boost_cleanup_funcs__[@]}"; do
        echo $f;
    done \
    | tac \
    | while read cleanup; do
        "${___info}" "Cleanup $(echo ${cleanup} | sed -e 's/^_//' -e 's/_cleanup//')... ";
        "${cleanup}";
        "${___info}" "done";
    done;
}

declare -a __bash_boost_required__=();
declare -a -g __bash_boost_cleanup_funcs__=();
trap __on_exit EXIT;

__bash_boost_required__+=(${BASH_SOURCE[0]});

#! /bin/bash
#
# require.sh -- 
#
#
function __require_file_1() {
    local file="${1}";
    source "${file}";
    __bash_boost_required__+=(${BASH_SOURCE[0]});
}

function __require_file_once() {
    local file="${1}";
    exist_array "${file}" && return;
    __required_file_1 "${file}";
}

function __require_file_force() {
    local file="${1}";
    __required_file_1 "${file}";
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
	    source_file_if_exist "${fullpath}" && {
		"__require_file_${___mode}" "${fullpath}";
		return 0;
	    }
	done
    done
    die "File not found. '${file}'";
    return 1;
}

function __invoke_init() {
    local func="_${___name}_init";
    exist_func "$func" || return;
    info  "Initializing ${___name}... ";
    "${func}";
    info "done";
}

function __add_cleanup() {
    local module_name="$1";
    local func="_${module_name}_cleanup";
    exist_func "$func" || return;
    __bash_boost_cleanup_funcs__+=("${func}");
}

function __require() {
    local file="$1";
    local ___name=$(echo $1 | sed -e 's/\.[^.]*$//');
    local require_path="${progdir}:${funcs_dir}:${extra_funcs_dir}:${class_dir}";
    exist_var BASHBOOSTPATH && {
	require_path="${BASHBOOSTPATH}:${require_path}";
    }
    info " require ${file}. ";
    __require_file "${file}" "${require_path}";
    __add_cleanup;
    __invoke_init;
    info "done";

    __bash_boost_required__+="${file}";
}

function require() {
    local __mode="once";
    local bash_file;
    [ "${1}" = "-f" ] && {
	__mode="force";
	shift;
    }
    for bash_file in "$@"; do
	__require ${bash_file};
    done;
}

function required_files() {
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
        info "Cleanup $(echo ${cleanup} | sed -e 's/^_//' -e 's/_cleanup//')... ";
        "${cleanup}";
        info "done";
    done;
}

declare -a __bash_boost_required__=();
declare -a -g __bash_boost_cleanup_funcs__=();
trap __on_exit EXIT;

__bash_boost_required__+=(${BASH_SOURCE[0]});

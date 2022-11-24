#! /bin/bash
#
# require.sh -- 
#
#
function __invoke_init() {
    local init_func="@${___name}_init";
    exist_func "${init_func}" || return 0;
    "${___info}" " Initializing ${___name}... ";
    "${init_func}";
    "${___info}" " done";
}

function __add_cleanup() {
    local func="@${___name}_cleanup";
    exist_func "${func}" || return 0;
    __bash_boost_cleanup_funcs__+=( "${func}" );
}

function __add_script_ready() {
    local func="@${___name}_script_ready";
    exist_func "${func}" || return 0;
    __bash_boost_script_ready_funcs__+=( "${func}" );
}

function __require_file() {
    local file="${1}";
    local ___name="$(basename "${file}" | sed -e 's/\.[^.]*$//')";
    "${___info}" "${___invoke} ${file}. ";
    source "${file}";
    __add_cleanup;
    __invoke_init;
    "${___info}" "done";
    __bash_boost_required__+=( "${file}" );
}

function __require_file_once() {
    local file="${1}";
    array_exists __bash_boost_required__ "${file}" && return 1;
    __require_file "${file}";
    return 0;
}

function __require_file_force() {
    local file="${1}";
    __require_file "${file}";
}

function __require_1() {
    local file="${1}";
    local path;
    local suffix;
    local fullpath;
    for path  in "${___paths[@]}"; do
	for suffix in "${___suffixes[@]}"; do
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

function __require_0() {
    local ___mode="once";
    local ___info=":";
    local opt;
    for opt in "$@"; do
	case "${opt}" in 
	-f) ___mode="force"; ;;
	-v) ___info="info";  ;;
	-s) ___info=":";     ;;
	 *) ;;
	esac
    done;
    local file;
    for file in "$@"; do
	case "${file}" in 
	-f|-v|-s) continue; ;;
	 *) __require_1 "${file}"; ;;
	esac
    done;
}

function __require() {
    local ___paths=(
	"$(echo "${___specified[@]}" | sed -e 's/:/ /g')"
	"${___default[@]}"
    );
    __require_0 "$@";
}

function require() {
    local ___invoke="${FUNCNAME}";
    local ___suffixes=( ".bash" ".sh" "" );
    local ___specified="${BASHBOOST_LIBPATH-""}";
    local ___default=("${progdir}" "${funcs_dir}");

    __require "$@";
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
    declare -a __bash_boost_cleanup_funcs_rev__=();
    local func;
    array_reverse __bash_boost_cleanup_funcs__ __bash_boost_cleanup_funcs_rev__;
    for cleanup in "${__bash_boost_cleanup_funcs_rev__[@]}"; do
        "${___info}" "Cleanup $(echo ${cleanup} | sed -e 's/^_//' -e 's/_cleanup//')... ";
        "${func}";
        "${___info}" "done";
    done;
}

function __on_script_ready() {
    local script_ready;
    info "Script ready...";
    for func in "${__bash_boost_script_ready_funcs__[@]}"; do
        "${func}";
    done;
    info "done";
}

function run() {
    local main="${1}";
    __on_script_ready;
    shift;
    "${main}" "$@";
}

declare -a __bash_boost_required__=();
declare -a -g __bash_boost_cleanup_funcs__=();
declare -a -g __bash_boost_script_ready_funcs__=();
trap __on_exit EXIT;

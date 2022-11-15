#! /bin/bash
#
# require.sh -- 
#
#
declare -A __bash_boost_required__=();

function __require_file() {
    local file="${1}";
    local paths="${2}";
    local suffixes=( ".bash" ".mod" ".class" ".sh" "" );
    local file;
    local fullpath;
    for path  in $(echo ${path} | sed -e 's/:/ /g'); do
	for suffix in "${suffixes}"; do
	    fullpath="${path}/${file}${suffix}";
	    __source_file_if_exist "${fullpath}" && {
		debug "${fullpath}";
		return 0;
	    }
	done
    done
    die "File not found. '${file}'";
    return 1;
}

function __require() {
    local file="$1";
    local require_path="${progdir}:${funcs_dir}";
    exist_var BASHBOOSTPATH && {
	require_path="${BASHBOOSTPATH}:${require_path}";
    }
    info " require ${file}. ";
    __require_file "${file}" "${require_path}";
    info "done";

    __bash_boost_required__+="${file}";
}

function __require_once() {
    local bash_file="$1";
    __array_exists "${bash_file}" __bash_boost_required__ && return;
    __require "${bash_file}";
}

function __require_force() {
    local bash_file="$1";
    __require "${bash_file}";
}

function require() {
    local mode="once";
    local bash_file;
    [ "${1}" = "-f" ] && {
	mode="force";
	shift;
    }
    for bash_file in "$@"; do
	"__require_${mode}" ${class};
    done;
}

#  他のファイルでオーバーライドされる。
#
#
function source_if_exist() {
    [ -f "$1" ] && {
        source "$1";
        info "$1";
    }
}

function array_exists() {
    local val="${1}";
    declare -n array="${2}";
    local v;
    for v in "${array[@]}"; do
        [ "${v}" == "${val}" ] && return 0;
    done
    return 1;
}


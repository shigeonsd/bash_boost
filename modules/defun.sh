#! /bin/bash
#
# defun.sh -- 関数定義
#
function exist_func() {
    [ "$(type -t $1)" = "function" ];
}

function exist_file() {
    test -f $1;
}

function array_exists() {
    local val="$1";
    local array="$2";
    for v in $array; do
	[ "${v}" == "${val}" ] && { return 0; }
    done
    return 1;
}

function sec2hms() {
    local t="$1";
    local s=0;
    local m=0;
    local h=0;
    ((s=t%60, m=(t%3600)/60, h=t/3600))
    printf "%02d:%02d:%02d" "$h" "$m" "$s";
}

function copy_function() {
    declare -F $1 > /dev/null || return 1
    eval "$(echo "${2}()"; declare -f ${1} | tail -n +2)"
}

function if_debug() {
    [[ -v DEBUG ]] || return 1;
    case $DEBUG in
    0|true)  return 0; ;;
    1|false) return 1; ;;
    esac
    return 1;
}

function if_true() {
    local var="${1}";
    [[ -v "${var}" ]] || return 1;
    case $(eval echo "\$${var}") in
    0|true)  return 0; ;;
    1|false) return 1; ;;
    esac
    return 1;
}

function create_fd() {
    local file="${1}";
    local fd=0;
    touch "${file}";
    exec  {fd}>"${file}";
    return ${fd};
}

function create_file() {
    local file="${1}";
    touch "${file}";
    echo ${file};
}

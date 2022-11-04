#! /bin/bash
#
# defun.sh -- 関数定義
#
function exist_func() {
    [ "$(type -t $1)" = "function" ];
}

function do_func_if_exists() {
    local func="${1}";
    exist_func $func || return;
    $@;
}

function exist_file() {
    test -f $1;
}

function exist_var() {
    [[ -v $1 ]];
}

function source_file_if_exists() {
    local file="${1}";
    exist_file ${file} || return;
    source ${file};
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
    declare -F $1 > /dev/null || return 1;
    eval "$(echo "${2}()"; declare -f ${1} | tail -n +2)";
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

function defun() {
    local funcname="${1}";
    local tmplfunc="${2}";
    copy_function "${tmplfunc}" "${funcname}";
}

function nop() {
    return 0;
}

function get_module_name() {
    echo $1 | sed -e 's/^__//' -e 's/_.*$//';
}

#
# 関数引数チェック
#
function error_if_noargs() {
    [ $# -eq 0 ] && error "No argument.";
}

function __required_n_args() {
    [ $# -ne ${___n} ] && error "Invalid arguments '$@'.";
}

function required_1_args() {
    local ___n=1;
    __required_n_args "$@";
}

function required_2_args() {
    local ___n=2;
    __required_n_args "$@";
}

function required_3_args() {
    local ___n=3;
    __required_n_args "$@";
}


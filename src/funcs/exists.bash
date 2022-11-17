#! /bin/bash
#
# exists.sh -- 存在確認関数
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

__bash_boost_required__+=(${BASH_SOURCE[0]});
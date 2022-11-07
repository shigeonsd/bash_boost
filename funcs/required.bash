#! /bin/bash
#
# required.sh -- 引数チェック関数
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

function required_args() {
    local n="${1}";
    local ope="${2}";
    local m="${3}";
    local args="${4}";
    [ $n -${ope} $m ] || die "Invalid arguments '${args}'.";
}

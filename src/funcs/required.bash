#! /bin/bash
#
# required.sh -- 引数チェック関数
#
function error_if_noargs() {
    [ $# -eq 0 ] && {
	die "No argument.";
    }
    return 0;
}

function __format_args() {
    local args="";
    local n="$#";
    local sep="";
    for a in "$@"; do
	args+="${sep}'${a}'";
	sep=", ";
    done
    echo "\$@=(${args}), \$#=${n}";
}

function __required_n_args() {
    [ $# -ne ${___n} ] && {
	local args=$(__format_args "$@");
	die "${args}: Required ${___n} argument(s).";
    }
    return 0;
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

function __required_ge_n_args() {
    [ $# -ge "${___n}" ] || {
	local args=$(__format_args "$@");
	die "${args}: Required over ${___n} argument(s).";
    }
    return 0;
}

function required_ge_1_args() {
    local ___n=1;
    __required_ge_n_args "$@";
}

function required_ge_2_args() {
    local ___n=2;
    __required_ge_n_args "$@";
}

function required_ge_3_args() {
    local ___n=3;
    __required_ge_n_args "$@";
}

function required_args() {
    [ "$@" ] || {
	local args=$(__format_args "$@");
	die "cond=[ $@ ]: Invalid argument(s)."; 
    }
    return 0;
}

function xrequired_args() {
    local n="${1}";
    local ope="${2}";
    local m="${3}";
    shift 3;
    [ $n -${ope} $m ] || {
	local args=$(__format_args "$@");
	die "cond=[ $n -${ope} $m ], ${args}: Invalid argument(s)."; 
    }
    return 0;
}

#! /bin/bash
#
# Hash.sh -- Hash クラス
#
#
use Object;

# Constructor
function Hash() {
    local ___super=Object;
    local ___class=${FUNCNAME};
    local ___this="${1}";
    shift;

    _new;
}

function Hash.set() {
    local key="$1";
    local val="$2";
    THIS[$n]=${val};
}

function Hash.get() {
    local n="$1";
    echo ${THIS[$n]};
}

function Hash.unset() {
    local n=$1;
    echo  ${THIS[$n]};
    unset THIS[$n];
    THIS=(${THIS[@]});
}

function Hash.length() {
    echo ${#THIS[@]};
}

function Hash.foreach() {
    local func="${1}";
    local k;
    for k in ${!THIS[@]}; do
	${func} ${k} ${THIS[$k]} || return $?;
    done;
    return 0;
}

function Hash.keys() {
    echo ${!THIS[@]};
}

function Hash.exists() {
    local val="$1";
    local k;
    for k in ${!THIS[@]}; do
        [ "${THIS[${k}]}" == "${val}" ] && return 0;
    done;
    return 1;
}

function Hash.key_exists() {
    local val="$1";
    local k;
    for k in ${!THIS[@]}; do
        [ "${k}" == "${val}" ] && return 0;
    done;
    return 1;
}

function Hash.clear() {
    THIS=();
}


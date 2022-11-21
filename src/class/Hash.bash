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
    declare -g -A "__${1}_props__";
    shift;

    _new "$@";
}

function Hash.operator_:=() {
    required_1_args "$@";
    local obj="${1}";
    copy_props ${obj} THIS;
    THIS = ${obj};
}

function Hash.operator_=() {
    required_1_args "$@";
    local _hash="${1}"
    unset -v THIS;
    declare -g -A THIS=$(declare -p ${_hash} | sed -e 's/^[^=]*=//' -e 's/\[/\n[/g' -e 's/)$/\n)/');
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

function Hash.map() {
    local func="${1}";
    local k;
    for k in ${!THIS[@]}; do
	"${func}" "${THIS[$k]}" "${k}" || return $?;
    done;
    return 0;
}

function Hash.keys() {
    echo ${!THIS[@]};
}

function Hash.exists() {
    local val="$1";
    local key;
    for key in ${!THIS[@]}; do
        [ "${THIS[${key}]}" == "${val}" ] && return 0;
    done;
    return 1;
}

function Hash.key_exists() {
    local val="$1";
    local key;
    for key in ${!THIS[@]}; do
        [ "${key}" == "${val}" ] && return 0;
    done;
    return 1;
}

function Hash.clear() {
    THIS=();
}

function Hash.serialize() {
    declare -p THIS | sed -e 's/^[^=]*=//' -e 's/\[/\n[/g' -e 's/ )$/\n)/';
}

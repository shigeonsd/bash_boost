#! /bin/bash
#
# Array.sh -- Array クラス
#
#
use Object;

# Constructor
function Array() {
    local ___super="Object";
    local ___class=${FUNCNAME};
    local ___this="${1}";
    local ___args
    shift;

    _new $@;
}

function Array.operator_=() {
    required_1_args $@;
    declare -n  _array="${1}"
    unset THIS
    declare -g -a THIS=$(declare -p ${!_array} | sed -e 's/^[^=]*=//' -e 's/\[/\n[/g' -e 's/)$/\n)/');
}

function Array.set() {
    local n="$1";
    local val="$2";
    THIS[$n]=${val};
}

function Array.get() {
    local n="$1";
    echo ${THIS[$n]};
}

function Array.unset() {
    local n=$1;
    echo  ${THIS[$n]};
    unset THIS[$n];
    THIS=(${THIS[@]});
}

function Array.push() {
    THIS+=($1);
}

function Array.pop() {
    local len=${#THIS[@]};
    local n=$((len -1));
    Array.unset $n;
}

function Array.unshift() {
    local _array=($1);
    _array+=(${THIS[@]});
    THIS=(${_array[@]});
}

function Array.shift() {
    Array.unset 0;
}

function Array.length() {
    echo ${#THIS[@]};
}

function Array.foreach() {
    local func="${1}";
    local e;
    for e in ${THIS[@]}; do
	${func} $e || return $?;
    done;
    return 0;
}

function Array.keys() {
    echo ${!THIS[@]};
}

function Array.clear() {
    THIS=();
}

function Array.exists() {
    local val="$1";
    local e;
    for e in ${THIS[@]}; do
        [ "${e}" == "${val}" ] && return 0;
    done;
    return 1;
}

function Array.reverse() {
    local e;
    local elm;
    for e in ${THIS[@]}; do
        echo "${e}";
    done \
    | tac \
    | while read elm ; do
	echo "${elm}";
    done
}

function Array.serialize() {
    declare -p THIS | sed -e 's/^[^=]*=//' -e 's/\[/\n[/g' -e 's/ )$/\n)/';
}

#! /bin/bash
#
# Array.sh -- Array クラス
#
#

# use Object;

# Array_props[obj_name,property_name]
# public      varname
# protected  _varname
# private   __varname
#
declare -g -A Array_props=();

# Constructor
function Array() {
    local ___this="${1}";
    local ___class=${FUNCNAME};
    shift;
    #_extends Object $@;

    public aaa 123;
    public bbb "xyz";
    public ccc "$(date)";
    public ddd ;

    _new;

    eval "${___this}=($@)";
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
    echo ${THIS[@]};
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

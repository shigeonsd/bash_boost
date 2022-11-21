#! /bin/bash
#
# array.bash -- 配列操作関数
#
function array_copy() {
    declare -n a1="${1}"; #from 
    declare -n a2="${2}"; #to

    a2=( "${a1[@]}" );
}

function array_set() {
    declare -n __array_ref="${1}";
    local n="$2";
    local val="$3";

    __array_ref[$n]=${val};
}

function array_get() {
    declare -n __array_ref="${1}";
    local n="$2";

    echo ${__array_ref[$n]};
}

function array_unset() {
    declare -n __array_ref="${1}";
    local n=$2;

    echo  ${__array_ref[$n]};
    unset __array_ref[$n];
    __array_ref=("${__array_ref[@]}");
}

function array_push() {
    declare -n __array_ref="${1}";
    __array_ref+=("$2");
}

function array_pop() {
    declare -n __array_ref="${1}";
    local len=${#__array_ref[@]};
    local n=$((len -1));
    array_unset "${1}" "$n";
}

function array_unshift() {
    declare -n __array_ref="${1}";
    local _array=($2);
    _array+=(${__array_ref[@]});
    __array_ref=(${_array[@]});
}

function array_shift() {
    array_unset "${1}" 0;
}

function array_length() {
    declare -n __array_ref="${1}";
    echo "${#__array_ref[@]}";
    return 0;
}

function array_map() {
    declare -n __array_ref="${1}"; 
    local func="${2}";
    local e;
    local index=0;
    for e in "${__array_ref[@]}"; do
        ${func} "$e" "${index}" || return $?;
	((index++));
    done;
    return 0;
}

function array_clear() {
    declare -n __array_ref="${1}";
    __array_ref=();
    return 0;
}

function array_exists() {
    declare -n __array_ref="${1}";
    local val="${2}";
    local v;
    for v in "${__array_ref[@]}"; do
	[ "${v}" == "${val}" ] && return 0;
    done
    return 1;
}

function array_reverse() {
    declare -n __array_ref="${1}";
    local e;
    local elm;
    for e in "${__array_ref[@]}"; do
        echo "${e}";
    done \
    | tac \
    | while read elm ; do
        echo "${elm}";
    done
}

function array_serialize() {
    declare -p "${1}"| sed -e 's/^[^=]*=//' -e 's/\[/\n[/g' -e 's/ )$/\n)/';
}


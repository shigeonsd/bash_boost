#! /bin/bash
#
# __array_ref.sh -- 配列用関数
#
function array_exists() {
    declare -n __array_ref="${1}";
    local val="${2}";
    local v;
    for v in "${__array_ref[@]}"; do
	[ "${v}" == "${val}" ] && return 0;
    done
    return 1;
}

function array_copy() {
    declare -n a1="${1}"; #from 
    declare -n a2="${2}"; #to

    a2=( "${a1[@]}" );
}

function array_map() {
    declare -n __array_ref="${1}"; 
    local func="${2}";
    local e;
    local index=0;
    for e in "${__array_ref[@]}"; do
        ${func} $e ${index} || return $?;
	((index++));
    done;
    return 0;
}

function array_clear() {
    declare -n __array_ref="${1}";
    __array_ref=();
    return 0;
}

function array_length() {
    declare -n __array_ref="${1}";
    echo "${#__array_ref[@]}";
    return 0;
}


#! /bin/bash
#
# array.sh -- 配列用関数
#
function array_exists() {
    declare -n array="${1}";
    local val="${2}";
    local v;
    for v in "${array[@]}"; do
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
    declare -n array="${1}"; 
    local func="${2}";
    local e;
    for e in "${array[@]}"; do
        ${func} $e || return $?;
    done;
    return 0;
}

function array_clear() {
    declare -n array="${1}";
    array=();
    return 0;
}

function array_length() {
    declare -n array="${1}";
    echo "${#array[@]}";
    return 0;
}


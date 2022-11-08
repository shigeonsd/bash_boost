#! /bin/bash
#
# array.sh -- 配列・連想配列用関数
#
function array_exists() {
    local val="${1}";
    declare -n array="${2}";
    local v;
    for v in "${array[@]}"; do
	[ "${v}" == "${val}" ] && { return 0; }
    done
    return 1;
}

function array_key_exists() {
    local key="${1}";
    declare -n array="${2}";
    local k;
    for k in "${!array[@]}"; do
	[ "${k}" == "${array[${key}]}" ] && { return 0; }
    done
    return 1;
}


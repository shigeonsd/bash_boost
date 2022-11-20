#! /bin/bash
#
# hash.bash --連想配列用関数
#
function hash_exists() {
    local val="${1}";
    declare -n hash="${2}";
    local v;
    for v in "${hash[@]}"; do
	[ "${v}" == "${val}" ] && return 0;
    done
    return 1;
}

function hash_key_exists() {
    local _key="${1}";
    declare -n hash="${2}";
    local key;
    for key in "${!hash[@]}"; do
	[ "${_key}" == "${key}" ] && return 0;
    done
    return 1;
}

function hash_copy() {
    declare -n h1="${1}"; # from
    declare -n h2="${2}"; # to
    local key;
    h2=();
    for key in "${!hash[@]}"; do
	h2["${key}"]=${h1["${ey}"]};
    done
}

function hash_map() {
    declare -n hash="${1}"; 
    local func="${2}";
    local k;
    for k in ${!hash[@]}; do
        ${func} "${hash[$k]}" "${k}" || return $?;
    done;
    return 0;
}

function hash_keys() {
    declare -n hash="${1}"; 

    echo "${!hash[@]}";
}

function hash_clear() {
    declare -n hash="${1}"; 
    hash=();
    return 0;
}

function hash_length() {
    declare -n hash="${1}";
    echo "${#hash[@]}";
    return 0;
}


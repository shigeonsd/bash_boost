#! /bin/bash
#
# hash.bash --連想配列用関数
#
function hash_compare() {
    declare -n h1="${1}";
    declare -n h2="${2}";

    local len1=$(hash_length h1);
    local len2=$(hash_length h2);

    [ "${len1}" -ne "${len2}" ] && return 1;

    local k=0;
    local n=$((len1 -1));
    for k in "${!h1[@]}"; do
        [ ! "${h1[$k]}" = "${h2[$k]}" ] && return 1;
    done;
    return 0;
}

function hash_copy() {
    declare -n h1="${1}"; # from
    declare -n h2="${2}"; # to
    local key;
    h2=();
    for key in "${!h1[@]}"; do
	h2["${key}"]=${h1["${key}"]};
    done
}

function hash_set() {
    declare -n __hash_ref="${1}";
    local key="${2}";
    local val="${3}";
    __hash_ref["$key"]="${val}";
}

function hash_get() {
    declare -n __hash_ref="${1}";
    local key="${2}";
    echo "${__hash_ref["${key}"]}";
}

function hash_unset() {
    declare -n __hash_ref="${1}";
    local key="${2}";
    echo  "${__hash_ref["${key}"]}";
    unset __hash_ref["${key}"];
}

function hash_length() {
    declare -n __hash_ref="${1}";
    echo "${#__hash_ref[@]}";
}

function hash_map() {
    declare -n __hash_ref="${1}"; 
    local func="${2}";
    local k;
    for k in "${!__hash_ref[@]}"; do
        ${func} "${__hash_ref[${k}]}" "${k}" || return $?;
    done;
    return 0;
}

function hash_clear() {
    declare -n __hash_ref="${1}"; 
    __hash_ref=();
    return 0;
}

function hash_keys() {
    declare -n __hash_ref="${1}"; 
    echo "${!__hash_ref[@]}";
}

function hash_exists() {
    declare -n __hash_ref="${1}";
    local val="${2}";
    local v;
    for v in "${__hash_ref[@]}"; do
	[ "${v}" == "${val}" ] && return 0;
    done
    return 1;
}

function hash_key_exists() {
    declare -n __hash_ref="${1}";
    local _key="${2}";
    local key;
    for key in "${!__hash_ref[@]}"; do
	[ "${_key}" == "${key}" ] && return 0;
    done
    return 1;
}

function hash_serialize() {
    declare -p "${1}"| sed -e 's/^[^=]*=//' -e 's/\[/\n[/g' -e 's/ )$/\n)/';
}

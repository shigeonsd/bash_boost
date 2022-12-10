#! /bin/bash
#
# is.bash -- 型判定関数
#
function is_empty() {
    local __str="${1}";
    [ -z "${__str}" ]
}

function is_numeric() {
    local __str="${1}";
    [[ "${__str}" =~ ^[+-]?[0-9]+$ ]]
}

function is_digit() {
    local __str="${1}";
    [[ "${__str}" =~ ^[[:digit:]]+$ ]]
}

function is_alpha() {
    local __str="${1}";
    [[ "${__str}" =~ ^[[:alpha:]]+$ ]]
}

function is_lower() {
    local __str="${1}";
    [[ "${__str}" =~ ^[[:lower:]]+$ ]]
}

function is_upper() {
    local __str="${1}";
    [[ "${__str}" =~ ^[[:upper:]]+$ ]]
}

function is_alnum() {
    local __str="${1}";
    [[ "${__str}" =~ ^[[:alnum:]]+$ ]]
}

function is_blank() {
    local __str="${1}";
    [[ "${__str}" =~ ^[[:blank:]]*$ ]]
}

function is_print() {
    local __str="${1}";
    [[ "${__str}" =~ ^[[:print:]]+$ ]]
}

function is_punct() {
    local __str="${1}";
    [[ "${__str}" =~ ^[[:punct:]]+$ ]]
}

function is_xdigit() {
    local __str="${1}";
    [[ "${__str}" =~ ^[[:xdigit:]]+$ ]]
}

function is_boolean() {
    local __str="${1}";
    case  "${__str}" in
    true|false|TRUE|FALSE) return 0; ;;
    esac
    return 1;
}

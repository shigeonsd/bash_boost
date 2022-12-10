#! /bin/bash
#
# is.bash -- 型判定関数
#
function is_empty() {
    declare -n __str="${1}";
    [ -z "${__str}" ]
}

function is_numeric() {
    declare -n __str="${1}";
    [[ "${__str}" =~ ^[+-]?[0-9]+$ ]]
}

function is_digit() {
    declare -n __str="${1}";
    [[ "${__str}" =~ ^[[:digit:]]+$ ]]
}

function is_alpha() {
    declare -n __str="${1}";
    [[ "${__str}" =~ ^[[:alpha:]]+$ ]]
}

function is_lower() {
    declare -n __str="${1}";
    [[ "${__str}" =~ ^[[:lower:]]+$ ]]
}

function is_upper() {
    declare -n __str="${1}";
    [[ "${__str}" =~ ^[[:upper:]]+$ ]]
}

function is_alnum() {
    declare -n __str="${1}";
    [[ "${__str}" =~ ^[[:alnum:]]+$ ]]
}

function is_blank() {
    declare -n __str="${1}";
    [[ "${__str}" =~ ^[[:blank:]]*$ ]]
}

function is_print() {
    declare -n __str="${1}";
    [[ "${__str}" =~ ^[[:print:]]+$ ]]
}

function is_punct() {
    declare -n __str="${1}";
    [[ "${__str}" =~ ^[[:punct:]]+$ ]]
}

function is_xdigit() {
    declare -n __str="${1}";
    [[ "${__str}" =~ ^[[:xdigit:]]+$ ]]
}

function is_boolean() {
    declare -n __str="${1}";
    case  "${__str}" in
    true|false|TRUE|FALSE) return 0; ;;
    esac
    return 1;
}

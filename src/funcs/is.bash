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
    [[ "${__str}" =~ ^[0-9]+$ ]]
}

function is_alpha() {
    declare -n __str="${1}";
    [[ "${__str}" =~ ^[a-zA-Z]+$ ]]
}

function is_alpha() {
    declare -n __str="${1}";
    [[ "${__str}" =~ ^[a-zA-Z]+$ ]]
}

function is_lower() {
    declare -n __str="${1}";
    [[ "${__str}" =~ ^[a-z-Z]+$ ]]
}

function is_alnum() {
    declare -n __str="${1}";
    [[ "${__str}" =~ ^[0-9a-zA-Z]+$ ]]
}

function is_whitespace() {
    declare -n __str="${1}";
    [[ "${__str}" =~ ^[ \t]*$ ]]
}

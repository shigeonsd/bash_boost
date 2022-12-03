#! /bin/bash
#
# string.bash -- 文字列操作関数
#
function string_length() {
    declare -n __str="${1}";
    ${#__str};
}
defun strlen string_length;

function string_compare() {
    declare -n __str1="${1}";
    declare -n __str2="${2}";
    [ "${__str1}" = "${__str2}" ];
}
defun strcmp string_compare;

function tolower() {
    declare -n __str="${1}";
    echo "${__str,,}";
}

function toupper() {
    declare -n __str="${1}";
    echo "${__str^^}";
}

#function camel() {
#}

#function snake() {
#}

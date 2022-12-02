#! /bin/bash
#
# misc.sh -- 
#
function sec2hms() {
    local t="$1";
    local s=0;
    local m=0;
    local h=0;
    ((s=t%60, m=(t%3600)/60, h=t/3600))
    printf "%02d:%02d:%02d" "$h" "$m" "$s";
}

function nop() {
    return 0;
}

function get_defined_functions() {
    declare -f | grep ' () $' | sed -e 's/ () //g'
}

function invoked_func() {
    local sp=${1-0};
    local frame=($(caller ${sp}));
    local func="${frame[1]}"
    echo "${func}";
}

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

function copy_function() {
    declare -F $1 > /dev/null || return 1;
    eval "$(echo "${2}()"; declare -f ${1} | tail -n +2)";
}

function nop() {
    return 0;
}

function get_module_name() {
    echo $1 | sed -e 's/^__//' -e 's/_.*$//';
}


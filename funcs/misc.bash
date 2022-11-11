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


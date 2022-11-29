#! /bin/bash
#
# debug.sh -- デバッグ支援
#
#function debug() {
#    if_debug || return 0;
#    _msg "DEBUG:" $@;
#}

declare -g __bash_boost_debug_indent__="";
function -indent() {
    if_debug || return 0;
    echo -n "${__bash_boost_debug_indent__}";
}

function stacktrace() {
    if_debug || return 0;
    local log=${1-info};
    local index=0;
    local frame="";
    "${log}" "stacktrace {"
    while frame=($(caller "${index}")); do
        ((index++))
        "${log}" "at function ${frame[1]} (${frame[2]}:${frame[0]})";
    done
    "${log}" "}"
}

function -var_dump() {
    if_debug || return 0;
    debug "$(-indent)var_dump {";
    for var in $@; do
        debug $(declare -p "${var}" | sed -e 's/^declare -[a-zA-Z\-][a-zA-z]*//');
    done;
    debug "$(-indent)}";
}

function -check_point() {
    if_debug || return 0;
    local frame=($(caller 0));
    debug "$(-indent)check_point: ${frame[1]} (${frame[2]}:${frame[0]})";
}

function ---() {
    if_debug || return 0;
    local funcname=${1-${FUNCNAME[1]}}
    debug "$(-indent)-------------------------";
}

function -enter() {
    if_debug || return 0;
    local funcname=${1-${FUNCNAME[1]}}
    debug "$(-indent)>>> ${funcname}() {";

    declare -n indent=__bash_boost_debug_indent__;
    indent+="    ";
}

function -leave() {
    if_debug || return 0;
    declare -n indent=__bash_boost_debug_indent__;
    indent=$(echo "${indent}" | sed -e 's/^    //');
    debug "$(-indent)}";
}

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

function -indent++() {
    if_debug || return 0;
    declare -n indent=__bash_boost_debug_indent__;
    indent+="    ";
}

function -indent--() {
    if_debug || return 0;
    declare -n indent=__bash_boost_debug_indent__;
    indent=$(echo "${indent}" | sed -e 's/^    //');
}

function stacktrace() {
    if_debug || return 0;
    local log=${1-info};
    local index=0;
    local frame="";
    "${log}" "$(-indent)stacktrace {"
    -indent++;
    while frame=($(caller "${index}")); do
        ((index++))
        "${log}" "$(-indent)at function ${frame[1]} (${frame[2]}:${frame[0]})";
    done
    -indent--;
    "${log}" "$(-indent)}"
}

function -var_dump() {
    if_debug || return 0;
    -echo "$(-indent)var_dump {";
    -indent++;
    for var in $@; do
	-echo "$(-indent)$(declare -p "${var}" | sed -e 's/^declare -[a-zA-Z\-][a-zA-z]*//')";
    done;
    -indent--;
    -echo "$(-indent)}";
}

function -check_point() {
    if_debug || return 0;
    local frame=($(caller 0));
    debug "check_point: ${frame[1]} (${frame[2]}:${frame[0]})";
}

function ---() {
    if_debug || return 0;
    local funcname=${1-${FUNCNAME[1]}}
    debug "-------------------------";
}

function -enter() {
    if_debug || return 0;
    local funcname=${1-${FUNCNAME[1]}}
    debug ">>> ${funcname}() {";
    -indent++;
}

function -leave() {
    if_debug || return 0;
    -indent--;
    debug "}";
}

function -echo() {
    debug "$@";
}

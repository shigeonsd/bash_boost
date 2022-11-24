#! /bin/bash
#
# debug.sh -- デバッグ支援
#
#function debug() {
#    if_debug || return 0;
#    _msg "DEBUG:" $@;
#}

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

function var_dump() {
    if_debug || return 0;
    debug "var_dump {";
    for var in $@; do
        debug $(declare -p "${var}" | sed -e 's/^declare -[a-zA-Z\-][a-zA-z]*//');
    done;
    debug "}";
}

function check_point() {
    if_debug || return 0;
}

function enter() {
    if_debug || return 0;
    local funcname=${1-${FUNCNAME[1]}}
    debug "enter ${funcname}() {";
}

function leave() {
    if_debug || return 0;
    local funcname=${1-${FUNCNAME[1]}}
    debug "leave ${funcname}() }";
}

function debug_before() {
    if_debug || return 0;
    local funcname=${1-${FUNCNAME[1]}}
    enter ${funcname};
}

function debug_after() {
    if_debug || return 0;
    local funcname=${1-${FUNCNAME[1]}}
    leave ${funcname};
}

function debug_around() {
    if_debug || {
	$@;
	return $?;
    }
    aop_around_template debug $@;
}

function debug_on_around() {
    local __debug="${DEBUG}";
    DEBUG="true";
    aop_around_template debug $@;
    DEBUG=${__debug};
}

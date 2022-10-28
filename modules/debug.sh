#! /bin/bash
#
# debug.sh -- デバッグ支援
#
defun __debug_info  mod_info;
defun __debug_debug mod_debug;

function stacktrace() {
    if_debug || return;
    local index=0;
    local frame="";
    __debug_debug "stacktrace {"
    while frame=($(caller "${index}")); do
	((index++))
	# at function <function name> (<file name>:<line no>)
	__debug_debug "at function ${frame[1]} (${frame[2]}:${frame[0]})";
    done
    __debug_debug "}"
}

function var_dump() {
    if_debug || return;
    __debug_debug "var_dump {";
    for var in $@; do
        __debug_debug $(declare -p "${var}" | sed -e 's/^declare -[a-zA-Z\-][a-zA-z]*//');
    done;
    __debug_debug "}";
}

function check_point() {
    if_debug || return;
}

function enter() {
    if_debug || return;
    local funcname=${1-${FUNCNAME[1]}}
    __debug_debug "enter ${funcname}() {";
}

function leave() {
    if_debug || return;
    local funcname=${1-${FUNCNAME[1]}}
    __debug_debug "leave ${funcname}() }";
}

function stacktrace_before() {
    if_debug || return;
    local funcname=${1-${FUNCNAME[1]}}
    stacktrace;
}

function debug_before() {
    if_debug || return;
    local funcname=${1-${FUNCNAME[1]}}
    enter ${funcname};
}

function debug_after() {
    if_debug || return;
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

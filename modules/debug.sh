#! /bin/bash
#
# debug.sh -- デバッグ支援
#
function _mod_debug() {
    mod_debug "${BASH_SOURCE[0]}" $@;
}

function stacktrace() {
    if_debug || return;
    local index=0;
    local frame="";
    _mod_debug "stacktrace {"
    while frame=($(caller "${index}")); do
	((index++))
	# at function <function name> (<file name>:<line no>)
	_mod_debug "at function ${frame[1]} (${frame[2]}:${frame[0]})";
    done
    _mod_debug "}"
}

function var_dump() {
    if_debug || return;
    _mod_debug "var_dump {";
    for var in $@; do
        _mod_debug $(declare -p "${var}" | sed -e 's/^declare -[a-zA-Z\-][a-zA-z]*//');
    done;
    _mod_debug "}";
}

function check_point() {
    if_debug || return;
}

function enter() {
    if_debug || return;
    local funcname=${1-${FUNCNAME[1]}}
    _mod_debug "enter ${funcname}() {";
}

function leave() {
    if_debug || return;
    local funcname=${1-${FUNCNAME[1]}}
    _mod_debug "leave ${funcname}() }";
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
    local _debug="${DEBUG}";
    DEBUG="true";
    aop_around_template debug $@;
    DEBUG=${_debug};
}

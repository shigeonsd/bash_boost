#! /bin/bash
#
# debug.sh -- デバッグ支援
#
function _mod_debug() {
    mod_debug "${BASH_SOURCE[0]}" $@;
}

function stacktrace() {
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

function _var_dump() {
    local var="$1";
    local val="$(eval "$(printf 'echo ${%s}\n' ${var})")";
    _mod_debug "${var}=${val}";
}

function var_dump() {
    _mod_debug "var_dump {";
    for var in $@; do
        _var_dump "${var}";
    done;
    _mod_debug "}";
}

function enter() {
    local funcname=${1-${FUNCNAME[1]}}
    _mod_debug "enter ${funcname}() {";
}

function leave() {
    local funcname=${1-${FUNCNAME[1]}}
    _mod_debug "leave ${funcname}() }";
}

function stacktrace_before() {
    local funcname=${1-${FUNCNAME[1]}}
    stacktrace;
}

function debug_before() {
    local funcname=${1-${FUNCNAME[1]}}
    enter ${funcname};
}

function debug_after() {
    local funcname=${1-${FUNCNAME[1]}}
    leave ${funcname};
}

function debug_around() {
    aop_around_template debug $@;
}

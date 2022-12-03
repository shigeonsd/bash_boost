#! /bin/bash
#
# debug.sh -- デバッグ支援
#
declare -g __bash_boost_debug_indent__="";

function -echo() { :; }
if_debug && {
    # デバッグモードの時のみメッセージを出力する。
    # (debug() をオーバーライドする）
    function -echo() { _msg "DEBUG:" "$(-indent)$@"; }
}

function -indent() {
    if_debug|| return 0;
    echo -n "${__bash_boost_debug_indent__}";
}

function -indent++() {
    if_debug|| return 0;
    declare -n indent=__bash_boost_debug_indent__;
    indent+="    ";
}

function -indent--() {
    if_debug|| return 0;
    declare -n indent=__bash_boost_debug_indent__;
    indent=$(echo "${indent}" | sed -e 's/^    //');
}

function stacktrace() {
    if_debug|| return 0;
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
    if_debug|| return 0;
    -echo "$(-indent)var_dump {";
    -indent++;
    for var in $@; do
	-echo "$(-indent)$(declare -p "${var}" | sed -e 's/^declare -[a-zA-Z\-][a-zA-z]*//')";
    done;
    -indent--;
    -echo "$(-indent)}";
}

function -check_point() {
    if_debug|| return 0;
    local frame=($(caller 0));
    -echo "check_point: ${frame[1]} (${frame[2]}:${frame[0]})";
}

function ---() {
    if_debug|| return 0;
    local funcname=${1-${FUNCNAME[1]}}
    -echo "-------------------------";
}

function -enter() {
    if_debug|| return 0;
    local funcname=${1-${FUNCNAME[1]}}
    -echo ">>> ${funcname}() {";
    -indent++;
}

function -leave() {
    if_debug|| return 0;
    -indent--;
    -echo "}";
}

## AOP Advices
function __debug_before() {
    ---
    declare -f "${___func}" | sed -e "s/^/$(-indent)/";
    ---
    -enter "${FUNCNAME}";
}

function __debug_after() {
    -echo "___ret=${___ret}";
    -leave;
}

function __debug_around() {
    ---
    declare -f "${___func}" | sed -e "s/^/$(-indent)/";
    ---
    -enter "${FUNCNAME}";
    $@;
    local ret=$?;
    -echo "___ret=${___ret}";
    -leave;
    return ${ret};
}

function __debug_after_returning() {
    -enter "${FUNCNAME}";
    -echo "Succeed";
    -leave;
}

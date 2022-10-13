#! /bin/bash
#
# aop.sh -- 
#
#
function __aop_info() {
    mod_info "${BASH_SOURCE[0]}" $@;
}

function __aop_debug() {
    mod_debug "${BASH_SOURCE[0]}" $@;
}

__aop_handlers="";
function _aop_set_handler() {
    local handlers=$(echo $1 | sed -e 's/\>/_aop/g');
    __aop_handlers="${__aop_handlers} ${handlers}";
}

__aop_before_handlers=();
function aop_before() {
    for h in $@; do
	__aop_before_handlers+=("${h}_before");
    done;
}

__aop_after_handlers=();
function aop_after() {
    for h in $@; do
	__aop_after_handlers+=("${h}_after");
    done;
}

__aop_around_handlers=();
function aop_around() {
    for h in $@; do
	__aop_around_handlers+=("${h}_around");
    done;
}

function __aop_before() {
    enter;
    for h in "${__aop_before_handlers[@]}"; do
        $h $@;
    done;
    leave;
}

function __aop_after() {
    enter;
    for h in "${__aop_after_handlers[@]}"; do
        echo $h;
    done \
    | tac \
    | while read _h; do
	$_h $@;
    done;
    leave;
}

function __aop_around() {
    enter;
    "${__aop_around_handlers[@]} $@";
    leave;
}

function aop_around_template() {
    local module_name=$1;
    local ret=0;
    shift;

    "${module_name}_before" ${___aop_cmd};
    $@;
    ret=$?
    "${module_name}_after" ${___aop_cmd};

    return ${ret};
}

function _aop_func() {
    local func="$1";
    copy_function "${func}" "__aop_orig_${func}";
    eval "function ${func}() { __aop \"__aop_orig_${func}\" \$@; }";
}

function aop_func() {
    for f in $@; do
	_aop_func "${f}";
    done;
}

function __aop() {
    local ___aop_cmd=$@;
    __aop_debug "$@ {";
    local ret=0;
    __aop_before $@;
    __aop_around $@;
    ret=$?;
    __aop_after $@;
    __aop_debug "}";
    return ${ret};
}

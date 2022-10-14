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

declare -A __aop_before_handlers;
__aop_before_handlers=();
function aop_before() {
    local func="${1}";
    local handlers=();
    shift;
    for h in $@; do
	handlers+=("${h}_before");
    done;
    echo ${handlers[@]};
    __aop_before_handlers["${func}"]+=${handlers[@]};
}

declare -A __aop_after_handlers;
__aop_after_handlers=();
function aop_after() {
    local func="${1}";
    local handlers=();
    shift;
    for h in $@; do
	handlers+=("${h}_before");
    done;
    __aop_after_handlers["${func}"]+=${handlers[@]};
}

declare -A __aop_around_handlers;
__aop_around_handlers=();
function aop_around() {
    local func="${1}";
    local handlers=();
    shift;
    for h in $@; do
	handlers+=("${h}_around");
    done;
    __aop_around_handlers["${func}"]+=${handlers[@]};
}

function __aop_before() {
    local func="${1}";
    local keys=${!__aop_before_handlers[@]};
    shift;
    array_exists "$func" "$keys" || return;
    local handlers=${__aop_before_handlers[${func}]};
    var_dump handlers;
    for h in ${handlers[@]}; do
        $h $@;
    done;
}

function __aop_after() {
    local func="${1}";
    local keys=${!__aop_after_handlers[@]};
    shift;
    array_exists "$func" "$keys" || return;
    local handlers=${__aop_after_handlers[${func}]};
    for h in ${handlers[@]}; do
        echo $h;
    done \
    | tac \
    | while read _h; do
	$_h $@;
    done;
}

function __aop_around() {
    local func="${1}";
    local keys=${!__aop_around_handlers[@]};
    array_exists "$func" "$keys" || return;
    shift;
    local handlers=${__aop_around_handlers[${func}]};
    debug ${handlers[@]} $@;
    ${handlers[@]} $@;
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

function __aop_cut_point() {
    local func="$1";
    local orig_func="__aop_orig_${func}";
    exist_func "${func}" || die "Not exists function ${func}().";
    exist_func ${orig_func} && {
	__aop_debug "Already exists __aop_orig_${func}().";
	return;
    }
    copy_function "${func}" "__aop_orig_${func}";
    eval "function ${func}() { __aop \"${func}\" \"__aop_orig_${func}\" \$@; }";
    if_debug && {
	__aop_debug "Rename ${func}() => __aop_orig_${func}()";
	declare -f __aop_orig_${func};
	__aop_debug "defun ${func}()";
	declare -f ${func};
    }
}

function aop_cut_point() {
    enter;
    local func="${1}";
    local join_point="${2}";
    shift; shift;
    __aop_cut_point "${func}";
    "aop_${join_point}" "${func}" $@;
    leave;
}

function __aop() {
    local func="${1}";
    local ___aop_cmd=$@;
    __aop_debug "${1}() {";
    local ret=0;
    __aop_before $@;
    __aop_around $@;
    ret=$?;
    __aop_after $@;
    __aop_debug "${1}() }";
    return ${ret};
}

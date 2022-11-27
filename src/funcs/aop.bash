#! /bin/bash
#
# aop.bash -- 
#
#

# JOINPOINT := [@before|@after|@around|@after_returning]
# ADVISOR   := file basename 
# ADVICE    := ジョインポイントに注入する関数
# POINTCUT  := アドバイスを注入する条件（関数名の指定）
# 
# __aop_<JOINPOINT>:array = ( "<ADVISOR>_<JOINPOINT>" ...)
#
# ADVISOR_JOINPOINT:hash = ( [POINTCUT]="ADVICE" ...)
#
declare -a -g __aop_before=();
declare -a -g __aop_after=();
declare -a -g __aop_around=();
declare -a -g __aop_after_returning=();
declare -a -g __aop_pontcuts=();

function __xaop_set_advice() {
    local _jp_array;
    local _jp_hash;
    local pointcut;
    local advice;
    local functions=$(get_defined_functions | grep -v '^_');
#    for func in "${functions[@]}"; do
    for _jp_array in __aop_before __aop_after __aop_around __aop_after_returning; do
	declare -n jp_array="${_jp_array}";
	for _jp_hash in "${jp_array[@]}"; do
	    declare -n jp_hash="${_jp_hash}";
	    for pointcut in "${!jp_hash[@]}"; do 
		advice="${jp_hash["${pointcut}"]}";
		echo pointcut="${pointcut}";
		echo advice="${advice}";
	    done;
	done;
    done;
#    done;
}

function __aop_do_join_point() {
    declare -n  jp_array="${1}";
    local      _jp_hash;
    local      _pointcut;
    local      advice;
    shift;
    for _jp_hash in "${jp_array[@]}"; do
	declare -n jp_hash="${_jp_hash}";
	for _pointcut in "${!jp_hash[@]}"; do 
	    advice="${jp_hash["${pointcut}"]}";
	    [[ "${___func}" =~ ${pointcut} ]] || continue;
	    "${advice}" "$@" || die "$(__ failed "${advice} $@")";
	done;
    done;
}

function __aop_do_before() {
    __aop_do_joinpoint __aop_before "$@";
}

function __aop_do_after() {
    __aop_do_joinpoint __aop_after "$@";
}

function __aop_do_after_returning() {
    __aop_do_joinpoint __aop_after_returning "$@";
}

function __aop_do_around() {
    "${__aop_around[@]}" $@;
}

function aop_around_template() {
    local ret;
    shift;

    $@;
    ret=$?

    return ${ret};
}

function __aop_injector_tmpl() {
    local ___func="${FUNCNAME}";
    local ___aop_cmd="$@";
    local ___ret=0;
    __aop_do_before "$@";
    __aop_do_around "$@";
    ___ret="$?";
    __aop_do_after_returning "$@";
    __aop_do_after "$@";
    return ${ret};
}

function __aop_wrap_func_with_injector() {
    local func="${1}";
    defun "${func}" "__aop_orig_${func}";
    defun __aop_injector_tmpl "${func}" \
}

function __aop_set_advice() {
    local func;
    local pointcut;
    while read func; do
	for pointcut in "${__aop_pointcuts[@]}"; do
	    [[ "${func}" =~ ${pointcut} ]] && {
		__aop_wrap_func_with_injector "${func}";
		break;
	    }
	done;
    done;
}

#
# @joinpoint advice pointcut ...
#

function __aop_add_joinpoint() {
    local joinpoint="${1}"; 
    local advice="${2}";
    local frame=($(caller 1));
    local advisor=$(basename "${frame[2]}" .bash);
    local pointcut;
    shift 2;

    local _h="__${advisor}_${joinpoint}";
    declare -A -g "${_h}";
    declare -n  jp_hash="${_h}";
    declare -n aop_jp_array="__aop_${joinpoint}";

    for pointcut in "$@"; do
	jp_hash["${pointcut}"]="${advice}";
	__aop_pointcuts+=("${pointcut}");
    done
    aop_jp_array+=( "${_h}" );
}

function @before() {
    __aop_add_joinpoint before "$@";
}

function @after() {
    __aop_add_joinpoint after "$@";
}

function @around() {
    __aop_add_joinpoint around "$@";
}

function @after_returning() {
    __aop_add_joinpoint after_returning "$@";
}

function __aop_dump() {
    local array;
    local pointcut;
    for array in __aop_before __aop_after __aop_around __aop_after_returning; do
	for pointcut in "${array[@]}"; do
	    declare -n hash="${pointcut}";
	    declare -p "${hash}";
	done;
    done;
}

#function _aop_init() {
#    :
#}

function _aop_script_ready() {
    enter;
    get_defined_functions \
	| grep -v '^_'  \
	| __aop_set_advice
    leave;
}

#function _aop_cleanup() {
#    :
#}

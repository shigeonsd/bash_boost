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

function __aop_do_joinpoint() {
    declare -n  jp_array="${1}";
    local      _jp_hash;
    local      _pointcut;
    local      advice;
    shift;
    
    for _jp_hash in "${jp_array[@]}"; do
	declare -n jp_hash="${_jp_hash}";
	for _pointcut in "${!jp_hash[@]}"; do 
	    advice="${jp_hash["${_pointcut}"]}";
	    [[ "${___func}" =~ ${_pointcut} ]] || continue;
	    debug "$(-indent)${advice} -> ${_pointcut}";
	    "${advice}" "$@" || die "$(__ failed "${advice} $@")";
	done;
    done;
}

function __aop_do_joinpoint2() {
    declare -n  jp_array="${1}";
    local      _jp_hash;
    local      _pointcut;
    local      advice;
    declare -a advice_array=();
    shift;
    
    for _jp_hash in "${jp_array[@]}"; do
	declare -n jp_hash="${_jp_hash}";
	for _pointcut in "${!jp_hash[@]}"; do 
	    advice="${jp_hash["${_pointcut}"]}";
	    [[ "${___func}" =~ ${_pointcut} ]] || continue;
	    debug "$(-indent)${advice} -> ${_pointcut}";
	    advice_array+=( "${advice}" );
	done;
    done;
    "${advice_array[@]}" "$@";
}

function __aop_do_before() {
    -enter
    __aop_do_joinpoint __aop_before "$@";
    -leave
}

function __aop_do_after() {
    -enter
    __aop_do_joinpoint __aop_after "$@";
    -leave
}

function __aop_do_after_returning() {
    -enter
    __aop_do_joinpoint __aop_after_returning "$@";
    -leave
}

function __aop_do_around() {
    -enter
    __aop_do_joinpoint2 __aop_around "$@";
    -leave
}

function aop_around_template() {
    local ret;
    #shift;
    "$@";
    ret=$?;
    return ${ret};
}

function __aop_injector_tmpl() {
    -enter;
    local ___func="${FUNCNAME}";
    local ___aop_cmd=("__aop_orig_${___func}" "$@");
    local ___ret=0;
    debug "__aop_cmd=${___aop_cmd[@]}";
    __aop_do_before "${___aop_cmd[@]}";
    __aop_do_around "${___aop_cmd[@]}";
    ___ret="$?";
    __aop_do_after_returning "${___aop_cmd[@]}";
    __aop_do_after "${___aop_cmd[@]}";
    -leave;
    return ${___ret};
}

function __aop_wrap_func_with_injector() {
    local func="${1}";
    defun "__aop_orig_${func}" "${func}";
    defun "${func}" __aop_injector_tmpl;
}

function __aop_pick_target_funcs() {
    local func;
    local pointcut;
    while read func; do
	for pointcut in "${__aop_pointcuts[@]}"; do
	    [[ "${func}" =~ ${pointcut} ]] && {
		echo "${func}";
		break;
	    }
	done;
    done;
}

function __aop_inject_advice() {
    local func;
    while read func; do
	__aop_wrap_func_with_injector "${func}";
	declare -f "${func}";
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
    array_exists aop_jp_array "${_h}" || {
	aop_jp_array+=( "${_h}" );
    }
}

function @before() {
    local frame=($(caller 0));
    local advice="__$(basename "${frame[2]}" .bash)_before";
    __aop_add_joinpoint before "${advice}" "$@";
}

function @Before() {
    __aop_add_joinpoint before "$@";
}

function @after() {
    local frame=($(caller 0));
    local advice="__$(basename "${frame[2]}" .bash)_after";
    __aop_add_joinpoint after "${advice}" "$@";
}

function @After() {
    __aop_add_joinpoint after "$@";
}

function @around() {
    local frame=($(caller 0));
    local advice="__$(basename "${frame[2]}" .bash)_around";
    __aop_add_joinpoint around "${advice}" "$@";
}

function @Around() {
    echo "$@"
    __aop_add_joinpoint around "$@";
}

function @after_returning() {
    local frame=($(caller 0));
    local advice="__$(basename "${frame[2]}" .bash)_after_returning";
    __aop_add_joinpoint after_returning "${advice}" "$@";
}

function @After_returning() {
    __aop_add_joinpoint after_returning "$@";
}

function __aop_dump() {
    local array;
    local pointcut;
    for array in __aop_before __aop_after __aop_around __aop_after_returning; do
	for pointcut in "${array[@]}"; do
	    declare -n hash="${pointcut}";
	    declare -p "${pointcut}";
	done;
    done;
}

#function _aop_init() {
#    :
#}

function _aop_script_ready() {
    local func;
    local target_funcs="$(get_defined_functions \
			| grep -v '^_'  \
			| grep -v '^-'  \
			| grep -v '^@'  \
			| __aop_pick_target_funcs)";
    for func in ${target_funcs[@]}; do
	debug "${func}";
	__aop_wrap_func_with_injector "${func}";
    done
}

#function _aop_cleanup() {
#    :
#}

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

function __aop_joinpoint() {
    declare -n  jp_array="${1}";
    local      _jp_hash;
    local      _pointcut;
    local      advices=();
    local      sep="";
    shift;
    
    for _jp_hash in "${jp_array[@]}"; do
	declare -n jp_hash="${_jp_hash}";
	for _pointcut in "${!jp_hash[@]}"; do 
	    advice="${jp_hash["${_pointcut}"]}";
	    #stacktrace;
	    [[ "${___func}" =~ ${_pointcut} ]] || continue;
	    -echo "${advice} -> ${_pointcut}";
	    advices+=( "${sep} ${advice} \"\${___aop_cmd[@]}\"" );
	    sep=";"
	done;
    done;
    [ ${#advices[@]} -eq 0 ] && {
	echo '#';
	return;
    }
    echo "${advices[@]}";
}

function __aop_joinpoint2() {
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
	    -echo "${advice} -> ${_pointcut}";
	    advice_array+=( "${advice}" );
	done;
    done;
    echo "${advice_array[@]}" " \"\${___aop_cmd[@]}\"";
}

function __aop_before_funcs() {
    -enter
    __aop_joinpoint __aop_before;
    -leave
}

function __aop_after_funcs() {
    -enter
    __aop_joinpoint __aop_after;
    -leave
}

function __aop_after_returning_funcs() {
    -enter
    local funcs="$(__aop_joinpoint __aop_after_returning)";
    [ "${funcs}" = "#" ] && {
	echo '#';
	-leave
	return;
    }
    echo "[ \${___ret} -eq 0 ] \&\& { "${funcs}"; }";
    -leave
}

function __aop_around_funcs() {
    -enter
    __aop_joinpoint2 __aop_around;
    -leave
}

function __aop_injector_tmpl() {
    -enter;
    local ___func="${FUNCNAME}";
    local ___aop_cmd=("__aop_orig_${___func}" "$@");
    local ___ret=0;
    -var_dump ___aop_cmd;
# "${___aop_cmd[@]}";
    __BEFORE__
    __AROUND__
    ___ret="$?";
    __AFTER_RETURNING__
    __AFTER__
    -leave;
    return ${___ret};
}

function __aop_wrap_func_with_injector() {
    -enter
    local ___func="${1}";
    defun "__aop_orig_${___func}" "${___func}";
    #defun "${func}" __aop_injector_tmpl;
    defun "${___func}" __aop_injector_tmpl                    \
	__BEFORE__           "$(__aop_before_funcs)"          \
	__AROUND__           "$(__aop_around_funcs)"          \
	__AFTER_RETURNING__  "$(__aop_after_returning_funcs)" \
	__AFTER__            "$(__aop_after_funcs)";
    -leave
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
    for array in __aop_before \
		 __aop_after  \
		 __aop_around \
		 __aop_after_returning; do
	for pointcut in "${array[@]}"; do
	    declare -n hash="${pointcut}";
	    declare -p "${pointcut}";
	done;
    done;
}

function _aop_script_ready() {
    -enter;
    local func;
    local target_funcs="$(get_defined_functions \
			    | grep -v '^_'  \
			    | grep -v '^-'  \
			    | grep -v '^@'  \
			    | __aop_pick_target_funcs)";
    for func in ${target_funcs[@]}; do
	-echo "${func}";
	__aop_wrap_func_with_injector "${func}";
    done
    -leave;
}


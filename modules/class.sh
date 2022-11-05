#! /bin/bash
#
# class.sh -- 
#
#
declare -A __object_props__=();

function __macroexpand() {
    local var=${1};
    local val=$2;
    sed -e "s/${var}/${val}/g" 
}

function __prop() {
    [ $# -eq 0 ] && {
	echo "${__object_props__[THIS,PROP]}";
	return 0;
    }
    [ $# -ne 2 ] && {
	die "Invalid argument '$@'.";
    }
    local operator="$1";
    local value=$2;
    [ ! "${operator}" =　"=" ] && {
	die "Invalid operator '${operator}'.";
    }
    # foo.dt = "1971/02/15 12:34:56";
    # NOTICE: 配列・連想配列はネストできない。
    validate TYPE "${value}" || die "Invalid data '${value}'.";
    __object_props__[THIS,PROP]="${value}";
    return 0;
}

function __validate_string() {
    local value="$@";
    : ne
}

function __validate_any() {
    local value="$@";
    : ne
}

function __validate_int() {
    local value="$@";
    : ne
    [[ ${value} =~ ^[+-]?[1-9][0-9]*$ ]];
}

function __validate_date() {
    local value="$@";
    date --date "${value}" '+%Y/%m/%d' > /dev/null 2>&1
}

function __validate_datetime() {
    local value="${@}";
    date --date "${value}" '+%Y/%m/%d %T' > /dev/null 2>&1
}

function validate() {
    local type="${1}";
    local value="${2}";

    __validate_${type} "${value}";
}

function __dump_this() {
    [[ -v ${___this} ]] && {
	declare -p ${___this} | sed -e 's/^declare -. //';
	return;
    }
    echo "${___this}=null";
}

function __dump_props() {
    local props=${!__object_props__[@]};
    local prop;
    local pname;
    for prop in ${props}; do
	[[ ${prop} =~ ^${___this}, ]] && {
	    pname=${prop/,/.};
	    echo "${pname}=${__object_props__[${prop}]};";
	}
    done;
}

function dump() {
    local ___this="${1}";
    __dump_this;
    __dump_props;
}

function __defprop() {
    [ $# -lt 2 ] && die "Invalid arguments '$@'";
	
    local type="$1";
    local prop="$2";
    local value=null;
    local props="__object_props__[${___this},${prop}]";
    shift 2;

    # 値の初期化
    [ $# -ne 2 ] && die "Invalid arguments '$@'";
    [ ! ${1} = '=' ] && die "Invalid operaotr '${1}'.";
    shift;
    value="$@";
    eval $(echo "${props}='${value}'");

    # アクセサ関数の追加
    eval "$(echo "${___this}.${___prefix}${prop}()";
	    declare -f __prop \
		|  tail -n +2 \
		| __macroexpand CLASS ${___class} \
		| __macroexpand PROP ${prop} \
		| __macroexpand TYPE ${type} \
		| __macroexpand THIS ${___this} )";
}

function __undefprops() {
    local props="\${!__object_props__[@]}";
    local prop;
    for prop in $(eval echo  ${props}); do
	[[ ${prop} =~ ^${___this}, ]] && {
	    echo "unset __object_props__[${prop}];";
	}
    done;
}

function __defmethods() {
    local method;
    for method in $(declare -f | grep "^${___class}\." | sed -e 's/ () //g'); do
	eval "$(declare -f ${method} \
		| __macroexpand ${___class} ${___this} \
		| __macroexpand CLASS ${___class} \
		| __macroexpand THIS ${___this}; )";
    done
}

function __undefmethods() {
    local method;
    for method in $(declare -f | grep "^${___this}\." | sed -e 's/ () //g'); do
	echo "unset -f ${method};";
    done;
}

function __defdestructor() {
     eval "$(echo "~${___this}() {";
	    __undef;
	    echo "}")";
}

function __undefdestructor() {
    echo "unset -f ~${___this};";
}

function __this() {
    local operator="operator_${1}";
    shift;
    "THIS.${operator}" "$@";
}

function __defthis() {
    eval "$(echo "${___this}()";
	    declare -f __this \
		|  tail -n +2 \
		| __macroexpand CLASS ${___class} \
		| __macroexpand THIS ${___this} )";
    defun ${____this} __this \
	CLASS ${__class} \
	THIS ${___this} \
}

function __undefthis() {
    echo "unset -f ${___this};";
}


function __super() {
    [ ${___super} = null ] && return;
    ${___super} ${___this};
}

function __init() {
    [ $# -eq 0 ] && return;

    local operator="${1}"
    shift;
    error_if_noargs "$@";

    eval "${___this} ${operator} \"$@\";";
}

function _new() {
    __super;
    public string class = "${___class}";
    __defthis;
    __defmethods;
    __defdestructor;
    __init "$@";
}

function copy_props() {
    local ___src="${1}";
    local ___dst="${2}";
    local props="\${!__object_props__[@]}";
    local src_prop;
    local dst_prop;
    for src_prop in $(eval echo  ${props} | sed -e 's/ /\n/g'| grep "^${___src},"); do
	dst_prop="$(echo ${src_prop} | sed -e "s/${___src}/${___dst}/")";
	__object_props__[${dst_prop}]="${__object_props__[${src_prop}]}";
    done;
}

function __undef() {
    __undefprops;
    __undefmethods;
    __undefdestructor;
}

function public() {
    local ___prefix="";
    __defprop "$@";
}

function protected() {
    local ___prefix="_";
    __defprop "$@";
}

function private() {
    local ___prefix="__";
    __defprop "$@";
}

function __delete() {
    local func="~${1}";

    exist_func  ${func} && echo "${func};";
}

function delete() {
    local obj;
    eval "$(for obj in "$@"; do
		__delete ${obj};
	    done;)"
}

function __load_class_file() {
    local class_name="${1}";
    local class_path="${2}";
    local class_file;
    for cp in $(echo ${class_path} | sed -e 's/:/ /g'); do
	class_file="${cp}/${class_name}.sh";
	__load_if_exist "${class_file}" && {
	    debug "${class_file}";
	    return 0;
	}
    done
    die "Class not found. '${class_name}'";
}

function _use() {
    local class_name="$1";

    [ -v "__${class_name}_loaded" ] && return ;

    local class_path="${progdir}:${class_dir}";
    exist_var BASHCLASSPATH && {
	class_path="${BASHCLASSPATH}:${class_path}";
    }
    __load_info " use ${class_name}. ";
    __load_class_file "${class_name}" "${class_path}";
    __load_info "done";
    __add_cleanup "${class_name}";
    __invoke_init "${class_name}";

    eval "__${class_name}_loaded=1";
}

function use() {
    case $1 in
    -s) __load_silence=true;
        defun_load_info  __load_info;
        defun_load_debug __load_debug;
        shift; ;;
    -v) __load_silence=false;
        defun_load_info  __load_info;
        defun_load_debug __load_debug;
        shift; ;;
    esac

    local class;
    for class in "$@"; do
	_use ${class};
    done;
}

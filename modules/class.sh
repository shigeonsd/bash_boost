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
	return;
    }
    local value="$1";
    validate TYPE "${value}";
    [ $# -eq 1 ] && {
	__object_props__[THIS,PROP]="${1}";
	return;
    }
    __object_props__[THIS,PROP]="$@";
}

function __validate_string() {
    local value="${1}";
    : ne
}

function __validate_int() {
    local value="${1}";
    : ne
}

function __validate_date() {
    local value="${1}";
    : ne
}

function __validate_datetime() {
    local value="${1}";
    : ne
}

function validate() {
    local type="${1}";
    local value="${2}";

    __validate_${type} "${value}";
}

function __dump_this() {
    declare -p ${___this} | sed -e 's/^declare -. //';
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
    local type="$1";
    local prop="$2";
    local value=null;
    local props="__object_props__[${___this},${prop}]";
    shift;

    # 値の初期化
    [ $# -ne 0 ] && {
	value="$@";
    }
    eval $(echo "${props}='${value}'");

    # アクセサ関数の追加
    eval "$(echo "${___this}.${prop}()";
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
    public string class "${___class}";
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
    __defprop "$@";
}

#function protected() {
#    __defprop "$@";
#}

#function private() {
#    __defprop "$@";
#}

function delete() {
    local obj;
    eval "$(for obj in "$@"; do
		echo "~${obj};";
	    done;)"
}

function _use() {
    local class_name="$1";

    [ -v "__${class_name}_loaded" ] && return ;

#declare -f __load_info;
    __load_info " use ${class_name}. ";
    __load_if_exist    "${progdir}/${class_name}.sh" \
        || __load_if_exist "${class_dir}/${class_name}.sh" \
            || die "Class not found. '${class_name}'";
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

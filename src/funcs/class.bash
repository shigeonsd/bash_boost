#! /bin/bash
#
# class.bash -- 
#
#
function __macroexpand() {
    local var=${1};
    local val=$2;
    sed -e "s/${var}/${val}/g" 
}

function __prop_tmpl() {
    declare -n props="$(__props_name "THIS")";
    [ $# -eq 0 ] && {
	echo "${props[PROP]}";
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
    props[PROP]="${value}";
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
	return 0;
    }
    -echo "${___this}=null";
}

function __dump_props() {
    declare -n props="$(__props_name "${___this}")";
    local prop;
    local pname;
    for prop in "${!props[@]}"; do
	-echo "${prop}=${props[${prop}]};";
    done;
}

function __props_name() {
    echo "__${1}_props__";
}

function is_object() {
    local props="$(__props_name "${1}")";
    [ -v "${props}" ]
}

function obj_dump() {
    if_debug || return 0;
    local ___this="${1}";
    -enter;
    -echo "object: ${___this}";
    ---;
    -echo "value:"
    __dump_this;
    ---;
    -echo "props:"
    __dump_props;
    -leave;
}

function __addprop() {
    local props_array="$(__props_name "${___this}")";
    [ $# -lt 2 ] && die "Invalid arguments '$@'";

    local type="$1";
    local prop="$2";
    local value=null;

    # サブクラスで当該プロパティが設定されているときはプロパティの追加・初期化はスキップする。
    hash_key_exists "${props_array}" "${prop}" && return 0;
	
    local props="${props_array}[${prop}]";
    shift 2;

    # 値の初期化
    [ $# -ne 2 ] && die "Invalid arguments '$@'";
    [ ! ${1} = '=' ] && die "Invalid operaotr '${1}'.";
    shift;
    value="$@";
    eval $(echo "${props}='${value}'");

    # アクセサ関数の追加
    local accessor="${___this}.${___prefix}${prop}"
    defun "${accessor}" __prop_tmpl \
	    CLASS "${___class}" \
	    PROP  "${prop}"     \
	    TYPE  "${type}"     \
	    THIS  "${___this}"  \
	    ;
}

function copy_props() {
    local src_props_hash="$(__props_name "${1}")";
    local dst_props_hash="$(__props_name "${2}")";

    hash_copy "${src_props_hash}" "${dst_props_hash}"
}

function __undefprop() {
    local props_array="$(__props_name "${___this}")";
    unset "${props_array}";
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
    eval "unset -f ~${___this};";
}

function ___this_tmpl() {
    local operator="operator_${1}";
    shift;
    "THIS.${operator}" "$@";
}

function __defthis() {
    defun ${___this} ___this_tmpl \
	CLASS ${___class} \
	THIS  ${___this} \
    ;
}

function __undefthis() {
    echo "unset -f ${___this};";
}

function __super() {
    [ ${___super} = null ] && return 0;
    ${___super} ${___this};
}

function __init() {
    [ $# -eq 0 ] && return 0;

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

function __undef() {
    __undefprop;
    __undefmethods;
    __undefdestructor;
}

function public() {
    local ___prefix="";
    __addprop "$@";
}

function protected() {
    local ___prefix="_";
    __addprop "$@";
}

function private() {
    local ___prefix="__";
    __addprop "$@";
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

function use() {
    local ___invoke="${FUNCNAME}";
    local ___suffixes=(".class" ".bash");
    local ___specified="${BASH_BOOST_CLASSPATH-""}";
    local ___default=("${progdir}" "${class_dir}");

    __require "$@";
}

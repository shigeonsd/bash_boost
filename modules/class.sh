#! /bin/bash
#
# class.sh -- 
#
#
function __macroexpand() {
    local var=${1};
    local val=$2;
    sed -e "s/${var}/${val}/g" 
}

function __prop() {
    [ $# -eq 0 ] && {
	echo "${CLASS_props[THIS,PROP]}";
	return;
    }
    [ $# -eq 1 ] && {
	CLASS_props[THIS,PROP]=$1;
	return;
    }
    CLASS_props[THIS,PROP]=$@;
}

function __dump_this() {
    echo "echo \$(declare -p ${___this} | sed -e 's/^declare -. //');"
}

function __dump_prop() {
    local props="\${!${___class}_props[@]}";
    local prop;
    local pname;
    for prop in $(eval echo  ${props}); do
	[[ ${prop} =~ ^${___this}, ]] && {
	    pname=${prop/,/.};
	    echo "echo ${pname}=\${${___class}_props[${prop}]};";
	}
    done;
}

function __defdump() {
     eval "$(echo "${___this}.dump() {";
	    __dump_this;
	    __dump_prop;
	    echo "}")";
}

function __undefdump() {
    echo "unset -f ${___this}.dump;";
}

function __defprop() {
    local prop="$1";
    local value=null;
    local props="${___class}_props[${___this},${prop}]";
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
		| __macroexpand THIS ${___this} )";
}

function __undefprops() {
    local props="\${!${___class}_props[@]}";
    local prop;
    for prop in $(eval echo  ${props}); do
	[[ ${prop} =~ ^${___this}, ]] && {
	    echo "unset ${___class}_props[${prop}];";
	}
    done;
}


function __defmethods() {
    local method;
    for method in $(declare -f | grep "^${___class}\." | sed -e 's/ () //g'); do
	eval "$(declare -f ${method} \
		| __macroexpand ${___class} ${___this} \
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

function _new() {
    public class "${___class}";
    __defdump;
    __defmethods;
    __defdestructor;
}

function __undef() {
    __undefprops;
    __undefdump;
    __undefmethods;
    __undefdestructor;
}

function public() {
    __defprop $@;
}

#function protected() {
#    __defprop $@;
#}

#function private() {
#    __defprop $@;
#}

function delete() {
    local obj;
    eval "$(for obj in $@; do
		echo "~${obj};";
	    done;)"
}

function _use() {
    local class_name="$1";

    [ -v "__${class_name}_loaded" ] && return ;

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
    local class;
    for class in $@; do
	_use ${class};
    done;
}

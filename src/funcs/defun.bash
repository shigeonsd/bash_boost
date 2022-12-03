#! /bin/bash
#
# template_method.sh -- 
#
#
function __create_macroexpand_func_0() {
    local mvar="";
    local mval="";
    local sed_opt="";

    for e in "${___macro[@]}"; do
	is_empty mvar && {
	    mvar="${e}";
	    continue;
	}
	mval="${e}";
	sed_opt="${sed_opt} -e 's/${mvar}/${mval}/g'";
	mvar="";
	mval="";
    done
    is_empty sed_opt && {
	echo "cat;";
	return 0;
    }
    echo "sed ${sed_opt};";
}

function __create_macroexpand_func() {
    local func="${1}";
    eval "$(echo "function ${func} () {";
	   __create_macroexpand_func_0;
	   echo "}";)";
}

function __funcname() {
    echo "function ${___func}()";
}

function __tmpl_func() {
    declare -f ${___tmpl_func} |  tail -n +2
}

function defun() {
    local ___func="${1}";
    local ___tmpl_func="${2}";
    shift 2;
    local ___macro=("$@");
    local macroexpand="__$(uuidgen | sed -e 's/-//g')";

    __create_macroexpand_func "${macroexpand}";
    eval "$(__funcname; __tmpl_func | "${macroexpand}";)";
    unset "${macroexpand}";
}

function copy_function() {
    declare -F "${1}" > /dev/null || return 1;
    eval "$(echo "${2}()"; declare -f "${1}" | tail -n +2)";
}

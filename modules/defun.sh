#! /bin/bash
#
# template_method.sh -- 
#
#

function __macroexpand() {
    local var=${1};
    local val=$2;
    sed -e "s/${var}/${val}/g"
}

function __macroexpand_0() {
    local mvar;
    local mval;

    echo cat;
    while [ ${#___macro[@]} -le 0 ]; do
	mvar=${___macro[0]};
	mval=${___macro[1]};
	shift 2;
	echo sed -e "s/${mvar}/${mval}/g"
    done
}

function __macroexpand() {
    eval "$(__macroexpand_0)";
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

    echo ${___macro[@]};
    eval "$(__funcname; __tmpl_func | __macroexpand)";
}

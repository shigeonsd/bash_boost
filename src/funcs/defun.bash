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
	is_empty "${mvar}" && {
	    mvar="${e}";
	    continue;
	}
	mval="${e}";
	sed_opt="${sed_opt} -e 's/${mvar}/${mval}/g'";
	mvar="";
	mval="";
    done
    is_empty "${sed_opt}" && {
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

function __lambda() {
    awk -v ___func="${___func}" \
	-v ___uuid="${___uuid}" \
'
BEGIN {
    count=0;
    lambda_count=0;
}
function _get_lambda_funcname() {
    return sprintf("%s_lambda_%d%s", ___func, count++, ___uuid);
}
function _def_lambda(lambda_funcname) {
    getline;
    lambda_end_line1 = $0;
    lambda_end_line2 = $0;
    gsub("{ ", "};", lambda_end_line1);
    gsub("{ ", "}",  lambda_end_line2);

    lambda_prog[lambda_count++] = sprintf("function %s() {", lambda_funcname);
    while (getline) {
	lambda_prog[lambda_count++] = $0;
	if (($0 == lambda_end_line1) || ($0 == lambda_end_line2)) {
	    break;
	}
    }
}
/\<lambda\>/ {
    lambda_funcname = _get_lambda_funcname();
    gsub("\\<lambda\\>", lambda_funcname, $0);
    print $0;
    _def_lambda(lambda_funcname);
    next;
}
{
    print $0;
}
END {
    for (i = 0; i < lambda_count; i++) {
	printf("%s\n", lambda_prog[i]);
    }
}
'
}

function lambda() {
    local ___func="${1}";
    local ___tmpl_func="${1}";
    local ___uuid="__$(uuidgen | sed -e 's/-//g')";

    #echo "$(__funcname; __tmpl_func | __lambda)";
    eval "$(__funcname; __tmpl_func | __lambda)";
}

function copy_function() {
    declare -F "${1}" > /dev/null || return 1;
    eval "$(echo "${2}()"; declare -f "${1}" | tail -n +2)";
}

#! /bin/bash
#
# preprocess.bash -- 
#
#
declare -a -g __bash_boost_preprocessor_target_funcs__=();

# @trycatch
#
function @preprocess() {
    local func="${1}";
    declare -n target_funcs=__bash_boost_preprocessor_target_funcs__;
    array_add target_funcs "${func}";
}

function __preprocessor_try_catch_throw_finally() {
    defun "${___func}" "${___func}"   \
	'\<try\>'      'declare -a ___exception=(); while true; do ' \
	'\<throw\>'    'break'                                       \
	'\<catch\>'    'break; done; array_empty ___exception || '   \
	'\<finally\>'  '#finally'                                    \
	';$'           ''
}
function __preprocessor_lambda() {
    lambda "${___func}"
}

function __do_preprocessor() {
    local ___func="${1}";
    __preprocessor_try_catch_throw_finally;
    __preprocessor_lambda;
}

function _preprocessor_script_ready() {
    -enter;
    local func;
    declare -n target_funcs=__bash_boost_preprocessor_target_funcs__;
    for func in ${target_funcs[@]}; do
	-echo "${func}";
	__do_preprocessor "${func}";
    done
    -leave;
}

function exception() {
    ___exception=( "$@" );
}


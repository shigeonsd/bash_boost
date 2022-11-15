#! /bin/bash
#
# ut.bash -- クラス用単体テスト実行
#
#
set -u;
progname=$(basename ${0});
progdir=$(cd "`dirname $0`" && pwd);

___ut_file="${1}";

function __source_ut_file() {
    [ ! -f "${___ut_file}" ] && {
	echo "File not found '${___ut_file}'."
	exit 1;
    }
    source "${___ut_file}";
}

function __do_func_if_exists() {
    local func="${1}";
    __exist_func $func || return;
    $@;
}

function __exist_func() {
    [ "$(type -t $1)" = "function" ];
}

function __get_test_funcs() {
    local f;
    declare -f  \
	| grep "^test__" \
	| sed -e 's/ () $//'  -e 's/___success$//' -e 's/___error$//' \
	| uniq \
	| while read f; do \
		echo "${f}___success";
		echo "${f}___error";
	  done ;
}

function __do_unit_test() {
    local log_dir=$(basename ${___ut_file} .ut);

    echo "Test target: ${___ut_file}";
    mkdir -p "${log_dir}";
    for f in $(__get_test_funcs) ; do
	local log_file="${log_dir}/${f}.out";
	local ret;
	(${f} >${log_file} 2>&1;)
	ret=$?
	case $ret in
	255) ((skipped++)); printf ' : %s -> skiped\n' $f; ;;
	0) ((success++));   printf '\033[32mo\033[m: %s -> ok\n' $f;   ;;
	*) ((failure++));   printf '\033[31mx\033[m: %s -> ng(%d)\n' $f $ret;   ;;
	esac
	((total++));
    done
    echo "${total} tests, ${success} success, ${failure} failure, ${skipped} skipped";
    echo ;
}

function __result() {
    [ $failure -ne 0 ] && exit 1;
    exit 0;
}

function success() {
    return 0;
}

function failure() {
    local frame=($(caller 0));
    echo  "FAILURE: failed at function ${frame[1]} (${frame[2]}:${frame[0]})" >&2
    return 1;
}

function skipped() {
    return -1;
}

DO_TEST_VAR_LF=false;
function __do_test() {
    local _bool=${1};
    local func=${2};
    shift 2;
    ( ${func} "$@" );
    ret=$?;

    local _args="";
    local _sep="";
    for a in "$@"; do
	_args+="${_sep}'${a}'";
	_sep=" ";
    done
    [ "${DO_TEST_VAR_LF}" == true ] && {
	echo ;
    }
    echo "## ${func} ${_args} => ${ret}";

    is_${_bool} ${ret};
    return $?;
}

function is_true() {
    [ $1 -eq 0 ];
}

function is_false() {
    [ $1 -ne 0 ];
}

function do_test_t() {
    __do_test true "$@";
    return $?
}

function do_test_f() {
    __do_test false "$@";
    return $?
}

total=0;
success=0;
failure=0;
skipped=0;
__source_ut_file;
__do_func_if_exists setup;
__do_unit_test;
__do_func_if_exists teardown;
__result;

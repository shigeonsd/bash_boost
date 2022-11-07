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
	255) ((skipped++)); echo " : $f -> skiped"; ;;
	0) ((success++));   echo "o: $f -> ok";   ;;
	*) ((failure++));   echo "x: $f -> ng($?)";   ;;
	esac
	((total++));
    done
    echo ;
    echo "${total} tests, ${success} success, ${failure} failure, ${skipped} skipped";
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

total=0;
success=0;
failure=0;
skipped=0;
__source_ut_file;
__do_func_if_exists setup;
__do_unit_test;
__do_func_if_exists teardown;
__result;

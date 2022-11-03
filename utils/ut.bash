#! /bin/bash
#
# ut.bash -- クラス用単体テスト実行
#
#
set -u;
progname=$(basename ${0});
progdir=$(cd "`dirname $0`" && pwd);

# モジュールの初期化
top_dir=$(dirname ${progdir});      
modules_dir="${top_dir}/modules";   
source "${modules_dir}/setup.sh";   

usage_option "UNIT_TEST_FILE";
usage_description "
    CLASS 用の単体テストプログラムを実行する。
";

# コマンドラインオプションの定義
usage_if_args_ne_1;  # オプションが指定されていなければ usage を表示する

___ut_file="${1}";

function source_ut_file() {
    exist_file "${___ut_file}" || die "File not found '${___ut_file}'."
    source "${___ut_file}";
}

function get_test_funcs() {
    { declare -f  | grep "test_${TARGET}_";
      declare -f  | grep "test_${TARGET}.operator_";
      declare -f  | grep "test_${TARGET}\." | grep -v "test_${TARGET}.operator_";
    } \
    | sed -e 's/ () $//';
}

function do_unit_test() {
    echo "Test target: ${TARGET}";
    for f in $(get_test_funcs) ; do
	# $f > /dev/null 2>&1;
	$f;
	case $? in
	255) ((skipped++)); echo " : $f -> skiped"; ;;
	0) ((success++));   echo "o: $f -> ok";   ;;
	*) ((failure++));   echo "x: $f -> ng($?)";   ;;
	esac
	((total++));
    done
    echo ;
    echo "${total} tests, ${success} success, ${failure} failure, ${skipped} skipped";
}

function result() {
    [ $failure -ne 0 ] && exit 1;
    exit 0;
}

function success() {
    delete obj;
    return 0;
}

function failure() {
    local frame=($(caller 0));
    echo  "FAILURE: failed at function ${frame[1]} (${frame[2]}:${frame[0]})" >&2
    delete obj;
    return 1;
}

function skipped() {
    return -1;
}

total=0;
success=0;
failure=0;
skipped=0;
source_ut_file;
do_func_if_exists setup;
do_unit_test;
do_func_if_exists teardown;
result;

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

function success() { result=0;  }
function failure() { result=1;  }
function skipped() { result=-1; }

function source_ut_file() {
    exist_file "${___ut_file}" || die "File not found '${___ut_file}'."
    source "${___ut_file}";
}

function do_unit_test() {
    { declare -f  | grep "test_${TARGET}_";
      declare -f  | grep "test_${TARGET}.operator_";
      declare -f  | grep "test_${TARGET}." | grep -v "test_${TARGET}.operator_";
    } \
    | sed -e 's/ () $//' \
    | { echo "Test target: ${TARGET}";
	    while read f; do
		$f;
		case $? in
		255) ((skipped++)); echo "?: $f -> skiped"; ;;
		0) ((success++));   echo "o: $f -> ok";   ;;
		*) ((failure++));   echo "x: $f -> ng($?)";   ;;
		esac
		((total++));
	    done
	    echo ;
	    echo "${total} tests, ${success} success, ${failure} failure, ${skipped} skipped";
	  }
}

function die() {
    false;
}

function result() {
    [ $failure -ne 0 ] && exit 1;
    exit 0;
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

#! /bin/bash
#
# ut.bash -- 
#
#
set -u;
progname=$(basename ${0});
progdir=$(cd "`dirname $0`" && pwd);
progargs=("$@");

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

function do_unit_test() {
    declare -f \
	| grep '^test::' \
	| sort \
	| ( echo "Test target:  ${TARGET}";
	    total=0;
	    success=0;
	    failure=0;
	    skipped=0;
	    while read f; do
		echo -n "$f => ";
		result=$($f);
		case "${result}" in
		success) ((success++)); echo "ok";   ;;
		failure) ((failure++)); echo "ng";   ;;
		skipped) ((skipped++)); echo "skiped"; ;;
		esac
		((total++));
	    done
	    echo "${total} tests, ${success} success, ${failure} failure, ${skipped} skipped";
	  )
}

source_ut_file;
do_func_if_exists setup;
do_unit_test;
do_func_if_exists teardown;

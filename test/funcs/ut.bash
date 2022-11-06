#! /bin/bash
#
# ut.bash -- クラス用単体テスト実行
#
#
set -u;
progname=$(basename ${0});
progdir=$(cd "`dirname $0`" && pwd);

# モジュールの初期化
top_dir=$(cd ${progdir}/../.. && pwd);
funcs_dir="${top_dir}/modules";
source "${funcs_dir}/vars.sh";   
source "${funcs_dir}/core.sh";   

___ut_file="${1}";

function source_ut_file() {
    exist_file "${___ut_file}" || die "File not found '${___ut_file}'."
    source "${___ut_file}";
}

function get_test_funcs() {
    local f;
    declare -f  \
	| grep "^test_" \
	| sed -e 's/ () $//'  -e 's/_success$//' -e 's/_error$//' \
	| uniq \
	| while read f; do \
		echo ${f}_success;
		echo ${f}_error;
	  done;
}

function do_unit_test() {
    local log_dir=$(basename ${___ut_file} .ut);

    echo "Test target: ${___ut_file}";
    mkdir -p "${log_dir}";
    for f in $(get_test_funcs) ; do
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

function result() {
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
source_ut_file;
do_func_if_exists setup;
do_unit_test;
do_func_if_exists teardown;
result;

#! /bin/bash
#
# mnkut.bash -- 単体テストプログラム生成
#
#
set -u;
progname=$(basename ${0});
progdir=$(dirname ${0});

# モジュールの初期化
top_dir="${progdir}/..";
utils_dir="${top_dir}/utils";
src_dir="${top_dir}/src";   
funcs_dir="${src_dir}/funcs";   
test_funcs_dir="${top_dir}/test/funcs";

___target="${1}";
___target_file="${funcs_dir}/${1}.bash";
___bashboost="${top_dir}/bash-boost.bash";
___ut_file="${2}";

function __setup_tmpl() {
    source "BASHBOOST";
    : require "TARGET";

    : テスト対象関数を関数をサブシェルを介して呼び出す true
    : テスト対象関数を関数をサブシェルを介さず呼び出す false
    : DO_TEST_SUBSHELL=false;
    __required_files;
}

function __teardown_tmpl() {
    :
}

function create_setup() {
    local ___func="setup";
    [ "$(type -t ${___func})" = "function" ] || {
	eval "$(echo "${___func} ()";
		declare -f "__${___func}_tmpl" \
		| tail -n +2  \
		| sed -e "s@\<BASHBOOST\>@${___bashboost}@g" \
		      -e "s@\<TARGET\>@${___target}@g" \
	)";
    }
    declare -f "${___func}";
}

function create_teardown() {
    local ___func="teardown";
    [ "$(type -t ${___func})" = "function" ] || {
	eval "$(echo "${___func} ()";
		declare -f "__${___func}_tmpl" \
		|  tail -n +2 
	)";
    }
    declare -f "${___func}";
}

function test_func_tmpl() {
    : テストスキップ
    return $(skipped);

    : テストデータ
    local data="12345";
    local expected="12345";

    : テスト実行
    : success
    :   'do_test_t <TEST_CONDITION> || return $(failure)';
    : failure
    :   'do_test_f <TEST_CONDITION> || return $(failure)';
	    
    : テスト成功
    return $(success) ;
}

function defun_ut_func() {
    local func="${1}";
    local case="${2}";
    local ut_func="test__${func}___${case}";
    [ "$(type -t ${ut_func})" = "function" ] || {
	eval "$(echo "${ut_func} ()";
	    declare -f test_func_tmpl \
		|  tail -n +2; 
	)";
    }
    declare -f "${ut_func}";
}


function create_ut() {
    ${utils_dir}/get_func_names.bash ${___target_file} \
	| ( local func;
	    while read func; do
		defun_ut_func ${func} success;
		defun_ut_func ${func} error;
	    done)
}

function source_ut_file() {
    [ -f  "${___ut_file}" ] || return;
    source "${___ut_file}";
}

function bash_header() {
    echo '#! /bin/bash';
    echo 'set -u';
}

source_ut_file;
bash_header;
create_setup;
create_ut;
create_teardown;

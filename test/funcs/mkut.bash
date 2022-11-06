#! /bin/bash
#
# mnkut.bash -- モジュール用単体テストプログラム生成
#
#
set -u;
progname=$(basename ${0});
progdir=$(cd "`dirname $0`" && pwd);

# モジュールの初期化
top_dir=$(cd ${progdir}/../.. && pwd);      
funcs_dir="${top_dir}/modules";   

# コマンドラインオプションの定義
#usage_if_args_ne_2;  # オプションが指定されていなければ usage を表示する

___func_file="${funcs_dir}/${1}.sh";
___ut_file="${2}";

function __tmpl() {
    :
}

function __create_func() {
    [ "$(type -t ${___func})" = "function" ] || {
	eval "$(echo "${___func} ()";
		declare -f "__tmpl" \
		|  tail -n +2 
	)";
    }
    declare -f "${___func}";
}

function create_setup() {
    local ___func="setup";
    __create_func;
}

function create_teardown() {
    local ___func="teardown";
    __create_func;
}

function test_func_tmpl() {
    : テストスキップ
    return $(skipped);

    : テストデータ
    local data="12345";
    local expected="12345";

    : テスト実行
    :   '<TEST_CONDITION> && return $(failure)';
    : success
    :   'obj.validate "1971/02/15"'
    :   '[ $? -eq 0 ] || return $(failure)';
    :   '[ ! $(obj.method ${data}) = "${expected}" ] || return $(failure)';
    : failure
    :   'obj.validate "1971/02/15xxxx"'
    :   '[ $? -ne 0 ] || return $(failure)';
    :   '[ $(obj.method ${data}) = "${expected}" ] || return $(failure)';
	    
    : テスト成功
    return $(success) ;
}

function defun_ut_func() {
    local func="${1}";
    local case="${2}";
    local ut_func="test_${func}_${case}";
    [ "$(type -t ${ut_func})" = "function" ] || {
	eval "$(echo "${ut_func} ()";
	    declare -f test_func_tmpl \
		|  tail -n +2; 
	)";
    }
    declare -f "${ut_func}";
}

function create_ut() {
    ${progdir}/get_func_names.bash ${___func_file} \
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

source_ut_file;
create_setup;
create_ut;
create_teardown;

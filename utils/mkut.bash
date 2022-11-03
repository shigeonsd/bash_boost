#! /bin/bash
#
# mnkut.bash -- 
#
#
set -u;
progname=$(basename ${0});
progdir=$(cd "`dirname $0`" && pwd);

# モジュールの初期化
top_dir=$(dirname ${progdir});      
modules_dir="${top_dir}/modules";   
source "${modules_dir}/setup.sh";   

usage_option "CLASS";
usage_option "UNIT_TEST_FILE";
usage_description "
    CLASS 用の単体テストプログラムを作成する。
";

# コマンドラインオプションの定義
usage_if_args_ne_2;  # オプションが指定されていなければ usage を表示する

___class="${1}";
___ut_file="${2}";
___object="_${___class}";

# 使用クラスの宣言
use -s ${___class};

function create_object() {
    # メソッド導出用のオブジェクト
    ${___class} ${___object};
}

function get_method_names() {
    declare -f | grep "^${___object}[. ]" | sed -e 's/^//' -e 's/ () $//' | sort;
}

function ut_func_tmpl() {
    : テストをスキップする
    return -1;

    : オブジェクト生成
    CLASS obj;

    : テストを実装する。
    local result;
    failure;
    : "test1 && test2 && test 3 && success;"
	    
    : オブジェクト破壊
    delete obj;

    return ${result};
}

function defun_ut_func() {
    exist_func "${___ut_func}" || {
	eval "$(echo "${___ut_func} ()";
	    declare -f "ut_func_tmpl" \
	    |  tail -n +2 \
	    | __macroexpand CLASS ${___class} \
	)";
    }
    declare -f "${___ut_func}";
}

function create_success_case() {
    local ___ut_func=$(printf "test${___method}_success");
    defun_ut_func;
}

function create_failure_case() {
    local ___ut_func=$(printf "test${___method}_failure");
    defun_ut_func;
}

function setup_tmpl() {
    TARGET="CLASS";
    use -s CLASS;
}

function create_setup() {
    eval "$(echo "setup ()";
	    declare -f "setup_tmpl" \
	    |  tail -n +2 \
	    | __macroexpand CLASS ${___class} )";
    declare -f setup;
}

function create_ut() {
    get_method_names \
	| ( local ___num=0;
	    local ___method;
	    while read ___method; do
		create_success_case;
		create_failure_case;
		((___num++))
	    done)
}

source_file_if_exists ${___ut_file};
create_object;

create_setup;
create_ut;

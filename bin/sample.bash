#! /bin/bash -x
#
# sample.bash -- toolkit.sh の使用例
#
set -u;
progname=$(basename ${0});
progdir=$(cd "`dirname $0`"; pwd);
progargs=$@

# モジュールの初期化
top_dir=$(dirname ${progdir});
modules_dir="${top_dir}/modules";
source "${modules_dir}/setup.sh";

# コマンドラインオプションの定義
function opt_x() { echo $FUNCNAME; }
function opt_y() { echo $FUNCNAME; }
function opt_z() { echo $FUNCNAME; }
function opt_q() { echo $FUNCNAME; exit; }
usage_option "-x|--exclude" opt_x;
usage_option "-y" opt_y;
usage_option "-z" opt_z;
usage_option "-q" opt_q;
usage_description "
    ここに使い方の詳細を書くこと。
    複数行記載できる。
    さらに詳しく.
";

# コマンドラインオプションの定義
usage_if_no_option;  # オプションが指定されていなければ usage を表示する
parse_option;        # コマンドラインオプションの解析

# 使用するモジュールのロード
load runtime proc_lock tmpdir laptime;

function foo_aaa() { info $FUNCNAME; };
function foo_bbb() { info $FUNCNAME; };
function foo_ccc() { info $FUNCNAME; };
load foo;

var_dump progname progdir progargs TMPDIR;

#aop_before stacktrace;
#aop_after  laptime foo;
#aop_around laptime;
#aop_around foo laptime debug;

function func1() {
    #log_begin_block;
    #laptime "check-1";
    info "aaa bbb ccc";
    sleep 1
    #log_end_block;
}

function func2() {
    log_begin_block;
    laptime "check-2";
    warn "ddd eee fff";
    sleep 3;
    log_end_block;
}

function func3() {
    error "ggg hhh iii";
    sleep 4;
    func4 128 256 512;
}

function func4() {
    local foo="123";
    local bar="abc";
    local baz=$(ls);

    var_dump foo bar baz;

    func5;
}

function func5() {
    echo XXX;
    true;
}

# AOP のテストコード
#aop_func func4;
#aop_cut_point func4 before foo stacktrace;
#aop_cut_point func4 around laptime debug;
aop_cut_point func1 before foo stacktrace;
aop_cut_point func1 around debug;
aop_cut_point func4 around foo laptime debug;

var_dump __aop_before_handlers;
var_dump __aop_after_handlers;
var_dump __aop_around_handlers;

function main() {
    local tmpfile="$(create_tmpfile)";
    echo "XXX ${tmpfile}";
    cat ${0} >&${tmpfile};
    func1;
    log_separater;
    func2 1 2 3;
    log_separater;
    func3;
    ls -al;
    log_separater;
    tmpdir;
    foo;
}

main;

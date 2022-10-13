#! /bin/bash
#
# sample.bash -- toolkit.sh の使用例
#
set -u;
progname=$(basename ${0});
progdir=$(cd "`dirname $0`"; pwd);
progargs=$@

top_dir=$(dirname ${progdir});
modules_dir="${top_dir}/modules";

# 使用方法を記載する。
# usage() で使用する。
usage_options="[lock|unlock]";
usage_description="
    ここに使い方の詳細を書くこと。
    複数行記載できる。
    さらに詳しく.
";

source "${modules_dir}/setup.sh";
load usage tmpdir laptime;

function foo_aaa() { info $FUNCNAME; };
function foo_bbb() { info $FUNCNAME; };
function foo_ccc() { info $FUNCNAME; };
load foo;

var_dump progname progdir progargs TMPDIR;

aop_before stacktrace;
#aop_after  laptime foo;
#aop_around laptime;
aop_around foo laptime debug;

var_dump __aop_before_handlers;
var_dump __aop_after_handlers;
var_dump __aop_around_handlers;

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
    func4
}

function func4() {
    local foo="123";
    local bar="abc";
    local baz=$(ls);

    var_dump foo bar baz;

    func5;
}

function func5() {
    stacktrace;
    func1;
}

function main() {
    parse_options;
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

aop_func func4;

main;

#! /bin/bash
#
# aop_sample.bash -- aop.bash の使用例
#
set -u;
source "$(cd $(dirname "$0") && pwd)/../../bash-boost.bash";
require aop;
require laptime_advisor;
require debug_advisor;
#require foo_advisor;
#require bar_advisor;

function func1() {
    echo "$(-indent)### ${FUNCNAME} ###";
    sleep 1;
    return 0;
}

function func2() {
    echo "$(-indent)### ${FUNCNAME} ###";
    sleep 1;
    return 0;
}

function func3() {
    echo "$(-indent)### ${FUNCNAME} ###";
    sleep 1;
    return 2;
}

function main() {
    func1;
    func2;
    func3;
}

run main "$@";

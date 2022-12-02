#! /bin/bash
#
# aop_sample.bash -- aop.bash の使用例
#
set -u;
source "$(cd $(dirname "$0") && pwd)/../../bash-boost.bash";
require aop;
require debug_advisor;
#require foo_advisor;
#require bar_advisor;

function func1() {
    echo "$(-indent)### ${FUNCNAME} ###";
}

function func2() {
    echo "$(-indent)### ${FUNCNAME} ###";
}

function func3() {
    echo "$(-indent)### ${FUNCNAME} ###";
}

function main() {
    func1;
    func2;
    func3;
}

run main "$@";

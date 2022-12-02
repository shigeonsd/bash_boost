#! /bin/bash
#
# aop_sample.bash -- aop.bash の使用例
#
set -u;
source "$(cd $(dirname "$0") && pwd)/../../bash-boost.bash";
require aop;
#require foo_advisor;
#require bar_advisor;
require debug_advisor;

function func1() {
    stacktrace;
}

function func2() {
    stacktrace;
}

function func3() {
    stacktrace;
}

function main() {
    __aop_dump;
    declare -f func1
    func1;
    declare -f func2
    func2;
    declare -f func3
    func3;
}

run main "$@";

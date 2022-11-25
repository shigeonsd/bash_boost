#! /bin/bash
#
# aop_sample.bash -- aop.bash の使用例
#
set -u;
source "$(cd $(dirname "$0") && pwd)/../../bash-boost.bash";
require debug;

#require aop;
#require foo_advice;

function func1() {
    echo
    enter;
    check_point;
    leave;
    echo
}

function func2() {
    echo
    enter;
    check_point;
    leave;
    echo
}

function func3() {
    echo
    enter;
    check_point;
    leave;
    echo
}

function main() {
    func1;
    func2;
    func3;
}

run main "$@";

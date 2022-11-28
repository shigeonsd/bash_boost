#! /bin/bash
#
# aop_sample.bash -- aop.bash の使用例
#
set -u;
source "$(cd $(dirname "$0") && pwd)/../../bash-boost.bash";
require aop;
#require foo_advisor;
require bar_advisor;

function func1() {
    echo "##{"
    enter;
    check_point;
    leave;
    echo "##}"
}

function func2() {
    echo "##{"
    enter;
    check_point;
    leave;
    echo "##}"
}

function func3() {
    echo "##{"
    enter;
    check_point;
    leave;
    echo "##}"
}

function main() {
    __aop_dump;
    func1;
    func2;
    func3;
}

run main "$@";

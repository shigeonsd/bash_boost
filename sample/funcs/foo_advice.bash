#! /bin/bash
#
# foo_advice.sh -- 
#
#
@before __foo_before '*func1' '*func3'
function __foo_before() {
    check_point;
}

@after __foo_after '*func1'
function __foo_after() {
    check_point;
}

@around 'func2'
function __foo_around() {
    enter;
    check_point;
    aop_around_template foo $@;
    leave;
}

@around_after_returning 'func3'; 
function __foo_around_returning() {
    enter;
    check_point;
    leave;
}

#! /bin/bash
#
# foo_advice.bash -- 
#
#
@before '.*func1' 'func3' 
function __foo_advisor_before() {
    -enter;
    -check_point;
    -leave;
}

@before 'func2'
function __foo_before2() {
    -enter;
    -check_point;
    -leave;
}

@after 'func1'
function __foo_advisor_after() {
    -enter;
    -check_point;
    -leave;
}

@around 'func2'
function __foo_advisor_around() {
    -enter;
    -check_point;
    aop_around_template $@;
    -leave;
}

@after_returning 'func3'; 
function __foo_advisor_after_returning() {
    -enter;
    -check_point;
    -leave;
}

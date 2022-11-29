#! /bin/bash
#
# bar_advice.bash -- 
#
#
@Before __bar_before1 '.*func1' 'func3' 
function __bar_before1() {
    -enter;
    -check_point;
    -leave;
}

@Before __bar_before2 'func2'
function __bar_before2() {
    -enter;
    -check_point;
    -leave;
}

@After __bar_after 'func1'
function __bar_after() {
    -enter;
    -check_point;
    -leave;
}

@Around __bar_around 'func2'
function __bar_around() {
    ---
    -enter;
    -check_point;
    aop_around_template $@;
    -leave;
    ---
}

@After_returning __bar_after_returning 'func3'; 
function __bar_after_returning() {
    ---
    -enter
    -check_point;
    -leave;
    ---
}

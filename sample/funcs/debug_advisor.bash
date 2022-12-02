#! /bin/bash
#
# debug_advice.bash -- 
#
#
@before 'func1' 'func3' 
function __debug_advisor_before() {
    -enter "${FUNCNAME} / ${___func}";
}

@after 'func1' 'func3'
function __debug_advisor_after() {
    -leave;
}

@around 'func2'
function __debug_advisor_around() {
    -enter "${FUNCNAME} / ${___func}";
    $@;
    -leave;
}

@after_returning 'func3'; 
function __debug_advisor_after_returning() {
    -enter;
    -echo "___ret=${___ret}";
    -leave;
}

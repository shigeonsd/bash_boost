#! /bin/bash
#
# debug_advice.bash -- 
#
#
@before 'func1' 'func2' 'func3' 
function __debug_advisor_before() {
    ---
    declare -f "${___func}" | sed -e "s/^/$(-indent)/";
    ---
    -enter "${FUNCNAME}";
}

@after 'func1' 'func2' 'func3'
function __debug_advisor_after() {
    -leave;
}

@around 'func2'
function __debug_advisor_around() {
    -enter "${FUNCNAME}";
    $@;
    -leave;
}

@after_returning 'func3'; 
function __debug_advisor_after_returning() {
    -enter "${FUNCNAME}";
    -echo "___ret=${___ret}";
    -leave;
}

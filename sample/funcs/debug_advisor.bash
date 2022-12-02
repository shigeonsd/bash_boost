#! /bin/bash
#
# debug_advice.bash -- 
#
#
@before 'func1' 'func3' 
function __debug_advisor_before() {
    ---
    declare -f "${___func}" | sed -e "s/^/$(-indent)/";
    ---
    -enter "${FUNCNAME}";
}

@after 'func1' 'func3'
function __debug_advisor_after() {
    -echo "___ret=${___ret}";
    -leave;
}

@around 'func2'
function __debug_advisor_around() {
    -enter "${FUNCNAME}";
    $@;
    local ret=$?;
    -echo "___ret=${___ret}";
    -leave;
    return ${ret};
}

@after_returning '^func.*'; 
function __debug_advisor_after_returning() {
    -enter "${FUNCNAME}";
    -echo "Succeed";
    -leave;
}

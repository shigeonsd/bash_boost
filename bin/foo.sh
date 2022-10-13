#! /bin/bash
#
# foo.sh -- 
#
#
function __foo_info() {
    mod_info "${BASH_SOURCE[0]}" $@;
}

function __foo_debug() {
    mod_debug "${BASH_SOURCE[0]}" $@;
}

interface \
    foo_aaa \
    foo_bbb \
    foo_ccc;

function foo() {
    foo_aaa;
    foo_bbb;
    foo_ccc;
}

function foo_before() {
    __foo_debug $FUNCNAME;
}

function foo_after() {
    __foo_debug $FUNCNAME;
}

function foo_around() {
    aop_around_template foo $@;
}

function _foo_init() {
    __foo_info $FUNCNAME;
}

function _foo_cleanup() {
    __foo_info $FUNCNAME;
}

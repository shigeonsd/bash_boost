#! /bin/bash
#
# Object.sh -- Object クラス
#
#

# Constructor
function Object() {
    local ___super=null;
    local ___class=${FUNCNAME};
    local ___this="$1";
    shift;

    public aaa a;
    public bbb b;
    public ccc c;

    _new "$@";
}

function Object.operator_:=() {
    required_1_args "$@";
    local obj="${1}";
    copy_props ${obj} THIS;
    eval "THIS = \${${obj}}";
}

function Object.operator_=() {
    error_if_noargs "$@";
    unset -v THIS;
    declare -g THIS;
    THIS="$@";
    #eval "THIS='$@';";
}

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

    _new;
}

function Object.test() {
    true;
}

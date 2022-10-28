#! /bin/bash
#
# Object.sh -- Object クラス
#
#

# Object_props[obj_name,property_name]
# public      varname
# protected  _varname
# private   __varname
#
declare -g -A Object_props=();

# Constructor
function Object() {
    local ___this="$1";
    local ___class=${FUNCNAME};
    shift;
    _new;
}

function Object.set() {
    THIS=${1};
}

function Object.get() {
    echo ${THIS};
}


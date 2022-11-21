#! /bin/bash
#
# DateTime.sh -- DateTime クラス
#
#
use Date;

# Constructor
function DateTime() {
    local ___super="Date";
    local ___class=${FUNCNAME};
    local ___this="${1}";
    declare -g -A "__${1}_props__";
    shift;

    public datetime fmt = '+%Y/%m/%d %T';

    _new "$@";
}


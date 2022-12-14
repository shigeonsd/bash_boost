#! /bin/bash
#
# Date.sh -- Date クラス
#
#
use Object;

# Constructor
function Date() {
    local ___super="Object";
    local ___class=${FUNCNAME};
    local ___this="${1}";
    declare -g -A "__${1}_props__";
    shift;

    public string fmt = '+%Y/%m/%d';

    _new "$@";
}

function Object.operator_=() {
    local fmt=$(THIS.fmt);
    error_if_noargs "$@";
    THIS.validate "$@" || die "Invalid date '$@'" ;
    unset -v THIS;
    declare -g THIS;
    THIS="$(date --date "$@" ${fmt})";
}

function Date.validate() {
    date --date "$@" > /dev/null 2>&1;
}

function Date.set() {
    THIS = ${1};
}

function Date.get() {
    local fmt=$(THIS.fmt);
    echo $(date --date "${THIS}" ${fmt});
}

function Date.n_days() {
    local fmt=$(THIS.fmt);
    local n="$1";
    date --date "${THIS} ${n} days" "${fmt}";
}

function Date.yesterday() {
    Date.n_days -1;
}

function Date.tomorrow() {
    Date.n_days 1;
}

function Date.end_of_month() {
    local fmt=$(Date.fmt);
    local n=$((${1-0}+1));
    date "${fmt}" --date "1 days ago $(date '+%Y/%m/01' --date "${THIS} ${n} months")"
}

function Date.begin_of_month() {
    local fmt=$(Date.fmt | sed -e 's/..$/01/');
    local n=${1-0};
    date "${fmt}" --date "${THIS} ${n} months";
}

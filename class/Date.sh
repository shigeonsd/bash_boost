#! /bin/bash
#
# Date.sh -- Date クラス
#
#

# Constructor
function Date() {
    local ___this="${1}";
    local ___class=${FUNCNAME};
    shift;
    local val=${1-$(date '+%Y/%m/%d')};

    public fmt '+%Y/%m/%d';

    _new;

    eval "${___this}='${val}'";
}

function Date.set() {
    THIS=${1};
}

function Date.get() {
    local fmt=$(Date.fmt);
    echo $(date --date "${THIS}" ${fmt});
}

function Date.n_days() {
    local fmt=$(Date.fmt);
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
    local fmt=$(Date.fmt);
    local n=${1-0};
    date "${fmt}" --date "${THIS} ${n} months";
}

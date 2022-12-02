#! /bin/bash
#
# date.sh -- 日付に関する定義
#
function today() {
    date '+%Y/%m/%d';
}

function now_ymd_hms() {
    date '+%Y%m%d_%H%M%S';
}

function now() {
    local fmt=${1-'+%Y/%m/%d %T'};
    date "${fmt}";
}

function now_sec() {
    local fmt=${1-'+%s'};
    date "${fmt}";
}

function n_days() {
    local fmt=$(THIS.fmt);
    local n="$1";
    date --date "${THIS} ${n} days" "${fmt}";
}

function tomorow() {
    local fmt=${1-'+%Y/%m/%d'};
    date --date '1 days' "${fmt}";
}

function yesterday() {
    local fmt=${1-'+%Y/%m/%d'};
    date --date '-1 days' "${fmt}";
}

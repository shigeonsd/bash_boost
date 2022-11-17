#! /bin/bash
#
# laptime.sh -- ログに関する定義
#
#
defun_load_info  __laptime_info;
defun_load_debug __laptime_debug;

#function __laptime_debug() {
#    mod_debug "${BASH_SOURCE[0]}" $@;
#}

function laptime() {
    local now_sec=$(date '+%s');
    local last_sec="${_lap_time}";
    local diff=$(($now_sec - $last_sec))
    local diff_hms=$(sec2hms $diff);
    local elapsed=$(($now_sec - $_lap_time_started))
    local elapsed_hms=$(sec2hms $elapsed);

    __laptime_debug " ${elapsed},${elapsed_hms},${diff},${diff_hms},"$@;
    _lap_time="${now_sec}";
}

function laptime_before() {
    local func=$1;
    laptime "before ${func}";
}

function laptime_after() {
    local func=$1;
    laptime "after ${func}";
}

function laptime_around() {
    aop_around_template laptime $@;
}

function _laptime_init() {
    local now_sec=$(date '+%s');
    _lap_time=0;
    _lap_time_started="${now_sec}";
    _lap_time="${now_sec}";

    __laptime_debug "elapsed(sec), elapsed(hms), diff(sec), diff(hms), checkpoint";
    laptime ${FUNCNAME};
}

function _laptime_cleanup() {
    laptime ${FUNCNAME};
}

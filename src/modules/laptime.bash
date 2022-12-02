#! /bin/bash
#
# laptime.sh -- ログに関する定義
#
#
declare -a -g __bash_boost_laptime_last__=0;
declare -a -g __bash_boost_laptime_started__=0;

function laptime() {
    declare -n    laptime_last=__bash_boost_laptime_last__;
    declare -n laptime_started=__bash_boost_laptime_started__;

    local         now=$(now_sec);
    local        diff=$((${now} - ${laptime_last}));
    local    diff_hms=$(sec2hms ${diff});
    local     elapsed=$((${now} - ${laptime_started}));
    local elapsed_hms=$(sec2hms ${elapsed});
    local       frame=($(caller 0));
    local        func="${1-"${frame[1]}"}";
    [ $# -ne 0 ] && shift;

    #info "$(-indent)@laptime: ${elapsed},${elapsed_hms},${diff},${diff_hms},${func},$@";
    info "@laptime: ${elapsed},${elapsed_hms},${diff},${diff_hms},${func},$@";
    laptime_last="${now}";
}

function __laptime_around() {
    -enter "${FUNCNAME}";
    laptime "${___func}";
    $@;
    local ret=$?;
    laptime "${___func}";
    -leave;
    return ${ret};
}

function _laptime_init() {
    declare -n    laptime_last=__bash_boost_laptime_last__;
    declare -n laptime_started=__bash_boost_laptime_started__;

    local now=$(now_sec);

    laptime_started="${now}";
    laptime_last="${now}";

    info "@laptime: elapsed(sec), elapsed(hms), diff(sec), diff(hms), checkpoint, note";
    laptime;
}

function _laptime_cleanup() {
    -enter;
    laptime;
    -leave;
}

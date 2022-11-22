#! /bin/bash
#
# log.sh -- ログに関する定義
#

function _msg() {
    shift;
    echo  $@ >&2; 
}

if_true BASH_BOOST_LOGGIN && {
    function _msg() {
	echo "$(now)" $@; >&2;
    }
}

# debug.bash でオーバーライドする。
function stacktrace() { :; };

function error() { _msg "ERROR:" $@; }
function warn()  { _msg "WARN:"  $@; }
function info()  { _msg "INFO:"  $@; }
function debug() { :; }
if_debug || {
    function debug() { _msg "DEBUG:" $@; }
}

function die() {
    local msg="$1";
    local exit_status="${2-1}" # 第二引数が指定されていなかったら 1
    error "exit_status=${exit_status}; ${msg}";
	
    __on_die;
    exit ${exit_status};
}

function __on_die() {
    if_debug && stacktrace error;
}



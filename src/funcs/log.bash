#! /bin/bash
#
# log.sh -- ログに関する定義
#

# ログファイル出力用の msg はこれよりも前に定義する。
exist_func _msg || {
    function _msg() { 
	shift;
	echo  $@ >&2; 
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
    if_debug && stacktrace error;
    exit ${exit_status};
}

__bash_boost_required__+=(${BASH_SOURCE[0]});

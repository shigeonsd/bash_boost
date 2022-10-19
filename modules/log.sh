#! /bin/bash
#
# log.sh -- ログに関する定義
#
function _msg() {
    echo "$(now)" $@; >&2;
}

function error() { _msg "ERROR:" $@; }
function warn()  { _msg "WARN:"  $@; }
function info()  { _msg "INFO:"  $@; }
function debug() { 
    if_debug || return;
    _msg "DEBUG:" $@; 
}

function die() {
    local msg=$1;
    local exit_status=${2-1} # 第二引数が指定されていなかったら 1
    error "exit_status=${exit_status}; ${msg}";
    exit ${exit_status};
}

function mod_info() {
    # モジュール名の前に @ を付けて出力する。
    # モジュール名を指定してログファイルを grep するときに他の文字列との衝突を防ぐ。
    local module_name=$(basename $1 | sed -e 's/.sh$//');
    shift;
    info "@${module_name}" $@; 
}

function mod_debug() {
    # モジュール名の前に @ を付けて出力する。
    # モジュール名を指定してログファイルを grep するときに他の文字列との衝突を防ぐ。
    local module_name=$(basename $1 | sed -e 's/.sh$//');
    shift;
    debug "@${module_name}" $@; 
}

function log_separater()   { info "----"; }
function log_begin_block() { info "${FUNCNAME[1]} {"; }
function log_end_block()   { info "}"; }

function __log_info() {
    mod_info "${BASH_SOURCE[0]}" $@;
}

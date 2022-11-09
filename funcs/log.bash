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
    if_debug || return 0;
    _msg "DEBUG:" $@; 
}

function __stacktrace() {
    local index=0;
    local frame="";
    error "stacktrace {"
    while frame=($(caller "${index}")); do
        ((index++))
        error "at function ${frame[1]} (${frame[2]}:${frame[0]})";
    done
    error "}"
}

function die() {
    local msg=$1;
    local exit_status=${2-1} # 第二引数が指定されていなかったら 1
    error "exit_status=${exit_status}; ${msg}";
    __stacktrace;
    exit ${exit_status};
}

function _get_module_name() {
    echo $1 | sed -e 's/^__//' -e 's/_[^_]*$//'
}

function mod_nop() {
    return 0;
}

function mod_info() {
    # モジュール名の前に @ を付けて出力する。
    # モジュール名を指定してログファイルを grep するときに他の文字列との衝突を防ぐ。
    #local module_name=$(basename ${bs} | sed -e 's/.sh$//');
    local module_name=$(_get_module_name ${FUNCNAME});
    info "@${module_name}" $@; 
}

function mod_debug() {
    # モジュール名の前に @ を付けて出力する。
    # モジュール名を指定してログファイルを grep するときに他の文字列との衝突を防ぐ。
    local module_name=$(_get_module_name ${FUNCNAME});
    debug "@${module_name}" $@; 
}

function log_separater()   { info "----"; }
function log_begin_block() { info "${FUNCNAME[1]} {"; }
function log_end_block()   { info "}"; }

function error_invalid_argument() {
    error "Invalid arguments $@.";
}

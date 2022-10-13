#! /bin/bash
#
# runtime.sh -- ログに関する定義
#
function _runtime_init() {
    __log_info "Runtime infomation {";
    __log_info "progname=$0";
    __log_info "args=${progargs}";
    __log_info "hostname=${hostname}";
    __log_info "user=${USER}";
    __log_info "now=$(now)";
    __log_info "PID=$$";
    __log_info "}";
}

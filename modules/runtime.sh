#! /bin/bash
#
# runtime.sh -- ログに関する定義
#
defun __runtime_info mod_info;

function _runtime_init() {
    __runtime_info "Runtime infomation {";
    __runtime_info "progname=$0";
    __runtime_info "args=${progargs}";
    __runtime_info "hostname=${hostname}";
    __runtime_info "user=${USER}";
    __runtime_info "now=$(now)";
    __runtime_info "PID=$$";
    __runtime_info "}";
}

#! /bin/bash
#
# proc_lock.sh -- プロセスロックに関する定義
#
#
load lock;

function __proc_lock_info() {
    if_load_silence_true && return;
    mod_info "${BASH_SOURCE[0]}" $@;
}

function _proc_lock_init() {
    lock_create ${progname};
    local ___lock_fd=$?;
    lock_or_die;
}

function _proc_lock_cleanup() {
    true;
}


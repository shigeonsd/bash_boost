#! /bin/bash
#
# proc_lock.sh -- プロセスロックに関する定義
#
#
load lock;

defun_load_info  __proc_lock_info;
defun_load_debug __proc_lock_debug; 

function _proc_lock_init() {
    lock_create ${progname};
    local ___lock_fd=$?;
    lock_or_die;
}

function _proc_lock_cleanup() {
    true;
}


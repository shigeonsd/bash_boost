#! /bin/bash
#
# lock.sh -- ロックに関する定義
#
#
lock_dir="${lock_dir-$(progdir)/lock}";

function __lock_info() {
    mod_info "${BASH_SOURCE[0]}" $@;
}

function __lock_debug() {
    mod_debug "${BASH_SOURCE[0]}" $@;
}

function lock_init() {
    local lockfile="${lock_dir}/${1}";
    exist_file $lockfile || die "Already exist ${lockfile}.";
}

function rlock() {
    local lockfile="${lock_dir}/${1}";
    shift;
}

function wlock() {
    local lockfile="${lock_dir}/${1}";
    shift;
}

function xlock() {
    local lockfile="${lock_dir}/${1}";

}

function _lock_init() {
    mkdir -p "${lock_dir}";
    __lock_info "Created ${TMPDIR}";
}

function _lock_cleanup() {
    __lock_info "Removed ${TMPDIR}";
}

#! /bin/bash
#
# lock.sh -- ロックに関する定義
#
#
function __lock_info() {
    if_load_silence_true && return;
    mod_info "${BASH_SOURCE[0]}" $@;
}

function __lock_debug() {
    mod_debug "${BASH_SOURCE[0]}" $@;
}

function lock_create() {
    local lock_file="${LOCKDIR}/${1}";
    local fd=0;
    exec {fd}>${lockfile};
    echo  ${fd};
}

function lock() {
    local lock_fd="${1}";
    flock -x "${lock_fd}";
}

function unlock() {
    local lock_fd="${1}";
    flock -u "${lock_fd}";
}

function synchronized() {
    local lock_file="${1}";
    shift;
    
    flock -x ${lock_file} $@;
}

function try_lock() {
    local lock_fd="${1}";
    flock -x --timeout=0 "${lock_fd}" || {
	warn "Already locked"
	return 1;
    };
    return 0;
}

function lock_or_die() {
    local lock_fd="${1}";
    flock -x --timeout=0 "${lock_fd}" || {
	die "Already locked";
    }
    return 0;
}

function _lock_init() {
    LOCKDIR="${LOCKDIR-${top_dir}/lock}"
    mkdir -p "${LOCKDIR}" && __lock_info "Created ${LOCKDIR}";
}

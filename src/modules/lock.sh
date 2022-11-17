#! /bin/bash
#
# lock.sh -- ロックに関する定義
#
#
defun_load_info  __lock_info;
defun_load_debug __lock_debug; 

declare -A __lock_fds;
__lock_fds=();
function lock_create() {
    local file="${LOCKDIR}/${1}";
    local key=$(basename ${1} | sed -e 's/\.//g');
    local keys=${!__lock_fds[@]};
    array_exists "$key" "$keys" && return;
    create_fd "${file}";
    local fd=$?;
    set +u
    __lock_fds["${key}"]="${fd}";
    set -u;
    return ${fd};
}

function __get_lock_fd() {
    return ${__lock_fds["${1}"]};
}

function lock() {
    local fd=${1-$___lock_fd};
    flock -x "${fd}";
}

function unlock() {
    local fd=${1-$___lock_fd};
    flock -u "${fd}";
}

function try_lock() {
    local fd=${1-$___lock_fd};
    flock -x --timeout=0 "${fd}" || {
	warn "Already locked."
	return 1;
    };
    return 0;
}

function lock_or_die() {
    local fd=${1-$___lock_fd};
    flock -x --timeout=0 "${fd}" || {
	die "Already locked.";
    }
    return 0;
}

function _lock_init() {
    LOCKDIR="${LOCKDIR-${top_dir}/lock}"
    mkdir -p "${LOCKDIR}" && __lock_info "Created ${LOCKDIR}";
}

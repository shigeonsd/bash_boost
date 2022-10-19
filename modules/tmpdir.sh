#! /bin/bash
#
# tmpdir.sh -- テンポラリディレクトリの自動生成と自動削除
#
#
function __tmpdir_info() {
    mod_info "${BASH_SOURCE[0]}" $@;
}

function tmpdir() {
    echo "${TMPDIR}";
}

function create_tmpfile() {
    mktemp;
}

function _tmpdir_init() {
    export TMPDIR=$(mktemp -d);
    __tmpdir_info "Created ${TMPDIR}";
}

function _tmpdir_cleanup() {
    # デバッグモードの時はテンポラリファイルは削除しない。
    if_debug  && return;
    rm -rf  ${TMPDIR};
    __tmpdir_info "Removed ${TMPDIR}";
}

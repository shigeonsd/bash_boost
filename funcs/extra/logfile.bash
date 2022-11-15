#! /bin/bash
#
# logtime.sh -- ログに関する定義
#
function _msg() {
    echo "$(now)" $@; >&2;
}

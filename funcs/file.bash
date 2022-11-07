#! /bin/bash
#
# file.sh -- ファイル操作関数
#
function create_fd() {
    local file="${1}";
    local fd=0;
    touch "${file}";
    exec  {fd}>"${file}";
    return ${fd};
}

function create_file() {
    local file="${1}";
    touch "${file}";
    echo ${file};
}


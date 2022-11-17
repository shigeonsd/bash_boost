#! /bin/bash
#
# file.sh -- ファイル操作関数
#
function create_fd() {
    local file="${1}";
    local fd=0;
    touch "${file}" || return 0;
    exec  {fd}>"${file}";
    return ${fd};
}

function create_file() {
    local file="${1}";
    touch "${file}" || {
	echo "";
	return 1;
    }
    echo ${file};
}


#! /bin/bash
#
# logger.sh -- ログ取得ラッパー
#
set -u
progname=$(basename ${0});
progdir=$(cd "`dirname $0`" && pwd);
progargs=$@;
command=$@;

top_dir=$(dirname ${progdir});
modules_dir="${top_dir}/modules";
log_dir="${top_dir}/log";

source "${modules_dir}/defun.sh";
source "${modules_dir}/date.sh";
source "${modules_dir}/log.sh";
source "${modules_dir}/usage.sh";

usage_option "command args...";
usage_description '
    "command args..." で指定したコマンドを実行し、画面出力をログファイルに記録する。
    記録されるログディレクトリは以下の通り。
        /home/nishida/src/shell_toolkit/log/YYYYMMDD/プログラム名/YYYYMMDD_HHMMSS.log
    最新のログファイルに対して newest が symlink される。
        /home/nishida/src/shell_toolkit/log/YYYYMMDD/プログラム名/newest
';
usage_if_no_option;
parse_option;

progname=$(basename ${1});
__log_dir="${log_dir}/$(today)/${progname}";
__log_file="${__log_dir}/$(now_ymd_hms).log";
__log_symlnk="${__log_dir}/newest";
VERBOSE=${VERBOSE-"false"};

function __setup_log_dir() {
    mkdir -p "${__log_dir}";
    rm -f "${__log_symlnk}";
    touch "${__log_file}";
    ln -s "${__log_file}" "${__log_symlnk}";
}

function __setup_verbose() {
    [ "${VERBOSE}" = "true" ] && return;
    #exec 1>"${__log_file}";
}

__setup_log_dir;
#__setup_verbose;
script -c "$*" -a "${__log_file}" > /dev/null 2>&1;

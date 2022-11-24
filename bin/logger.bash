#! /bin/bash
#
# logger.sh -- ログ取得ラッパー
#
set -u
source "$(cd $(dirname "$0") && pwd)/../bash-boost.bash";

function __getopt2() {
    [ $# -le 0 ] && die "No specified command.";

    local progname=$(basename ${1});
    __log_dir="${log_dir}/$(today)/${progname}";
    __log_file="${__log_dir}/$(now_ymd_hms).log";
    __log_symlnk="${__log_dir}/newest";

    cmd="${1}";
    shift;
    local _args=("$@");
    args="$(array_quoted_values _args)";
}

usage "command args..." <<_
    "command args..." で指定したコマンドを実行し、画面出力をログファイルに記録する。
    記録されるログディレクトリは以下の通り。
        /home/nishida/src/shell_toolkit/log/YYYYMMDD/プログラム名/YYYYMMDD_HHMMSS.log
    最新のログファイルに対して newest が symlink される。
        /home/nishida/src/shell_toolkit/log/YYYYMMDD/プログラム名/newest
_
usage_chkopt ge 1;
usage_getopt : __getopt2;

VERBOSE=${VERBOSE-"false"};
export BASH_BOOST_LOGGING=true;

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

function get_command_exit_code() {
    tail -1 "${__log_file}" \
	| sed -e 's/.*[COMMAND_EXIT_CODE="//' \
	      -e 's/"]$"//'		    
}

__setup_log_dir;
#__setup_verbose;
script -c "${cmd} ${args}" -a "${__log_file}" > /dev/null 2>&1;

exit "$(get_command_exit_code)";

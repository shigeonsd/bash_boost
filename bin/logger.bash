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

source "${modules_dir}/date.sh";

usage_options="[-v|--verbose] command args...";
usage_description="
    \"command args...\" で指定したコマンドを実行し、画面出力をログファイルに記録する。
    記録されるログディレクトリは以下の通り。
	${log_dir}/$(today)/プログラム名/YYYYMMDD_HHMMSS.log
    最新のログファイルに対して newest が symlink される。
	${log_dir}/$(today)/プログラム名/newest
";
#case "${1}" in
#-v|--verbose) shift; ;;
#*) exec 1>>/dev/null; ;;
#esac
#source "${modules_dir}/usage.sh";

progname=$(basename ${1});
__log_dir="${log_dir}/$(today)/${progname}";
__log_file="${__log_dir}/$(now_ymd_hms).log";
__log_symlnk="${__log_dir}/newest";


function __log_dir_setup() {
    mkdir -p "${__log_dir}";
    rm -f "${__log_symlnk}";
    touch "${__log_file}";
    ln -s "${__log_file}" "${__log_symlnk}";
}

__log_dir_setup;
exec script -c "$*" -a "${__log_file}" 2>&1

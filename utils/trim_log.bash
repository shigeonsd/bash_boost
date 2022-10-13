#! /bin/bash 
#
# trimlog.bash -- ログファイルのトリミング
#
set -u;
progname=$(basename ${0});
progdir=$(cd "`dirname $0`"; pwd);
progargs=$@

top_dir=$(dirname ${progdir});
modules_dir="${top_dir}/modules";

# 使用方法を記載する。
# usage() で使用する。
usage_options="[logfile|-]";
usage_description="
    引数で指定されたログ種別のみを取り出し、第３フールドまでをトリミングする。
    logファイルが省略されたときは newest を処理対象ファイルにする。
";
source "${modules_dir}/usage.sh"
load usage;

function __trim_log() {
    sed -e 's@^..../../.. ........ [^:]*: @@'
}

__trim_log;


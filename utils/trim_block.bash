#! /bin/bash 
#
# trimlog.bash -- ログファイルのトリミング
#
set -u;
progname=$(basename ${0});
progdir=$(cd "`dirname $0`"; pwd);
top_dir="${progdir}/..";
module_dir="${top_dir}/modules";

# 使用方法を記載する。
# usage() で使用する。
usage_options="block_name [logfile]";
usage_description="
    引数で指定されたブロックを取り出し、第３フールドまでをトリミングする。
    logファイルが省略されたときは newest を処理対象ファイルにする。
";
source "${module_dir}/usage.sh"

function __trim_block() {
    awk "
/${block_name} {/, /}/ { print; }
{ next; }
";
}

block_name=$1;
target_file="newest";
if [ $# -gt 1 ]; then
    target_file=$2;
fi

cat "${target_file}" | __trim_block


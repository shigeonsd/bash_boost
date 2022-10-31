#! /bin/bash  
#
# hash_test.bash -- 
#
#
set -u;
progname=$(basename ${0});
progdir=$(cd "`dirname $0`" && pwd);
progargs=$@

# モジュールの初期化
top_dir=$(dirname ${progdir});
modules_dir="${top_dir}/modules";
source "${modules_dir}/setup.sh";

# 使用クラスの宣言
use Date;

echo Date d;
Date d;

d.dump;

echo d.yesterday;
d.yesterday;

echo d.tomorrow;
d.tomorrow;

echo d.begin_of_month -1;
d.begin_of_month -1;
echo d.end_of_month -1;
d.end_of_month -1;

echo d.begin_of_month;
d.begin_of_month;
echo d.end_of_month;
d.end_of_month;

echo d.begin_of_month 1;
d.begin_of_month 1;
echo d.end_of_month 1;
d.end_of_month 1;

echo delete d;
delete d;

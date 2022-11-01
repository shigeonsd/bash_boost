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

#declare -g d;
echo Date d;
Date d = "1971/02/15";

dump d;

echo d.yesterday;
d.yesterday;

echo d.tomorrow;
d.tomorrow;

echo d.fmt '+%Y-%m-%d'
d.fmt '+%Y-%m-%d'

echo Date d2; 
Date d2; 
d2=$(today);

echo d2 = d;
dump d2;

echo d2 = d;
d2 = d;

echo d2.begin_of_month -1;
d2.begin_of_month -1;
echo d.end_of_month -1;
d2.end_of_month -1;

echo d.begin_of_month;
d2.begin_of_month;
echo d.end_of_month;
d2.end_of_month;

echo d.begin_of_month 1;
d2.begin_of_month 1;
echo d.end_of_month 1;
d2.end_of_month 1;

echo delete d;
delete d d2;

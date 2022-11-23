#! /bin/bash 
#
# datetime_test.bash -- 
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
use DateTime;

#declare -g d;
echo DateTime dt;
DateTime dt = "1971/02/15 12:34:56";

dump dt;

echo d.yesterday;
dt.yesterday;

echo d.tomorrow;
dt.tomorrow;

echo d.fmt '+%Y-%m-%d %T'
dt.fmt '+%Y-%m-%d %T'

echo DateTime d2; 
DateTime dt2; 
dt2 = $(now);

echo dump dt2;
dump dt2;

echo d2 := d;
dt2 := dt;

echo dt2.begin_of_month -1;
dt2.begin_of_month -1;
echo d.end_of_month -1;
dt2.end_of_month -1;

echo d.begin_of_month;
dt2.begin_of_month;
echo d.end_of_month;
dt2.end_of_month;

echo d.begin_of_month 1;
dt2.begin_of_month 1;
echo d.end_of_month 1;
dt2.end_of_month 1;

echo delete dt dt2;
delete dt dt2;

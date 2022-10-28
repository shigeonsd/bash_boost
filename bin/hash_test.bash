#! /bin/bash
#
# hash_test.bash -- 
#
#
set -u;
progname=$(basename ${0});
progdir=$(cd "`dirname $0`"; pwd);
progargs=$@

# モジュールの初期化
top_dir=$(dirname ${progdir});
modules_dir="${top_dir}/modules";
source "${modules_dir}/setup.sh";

# 使用クラスの宣言
use Hash;

echo Hash h;
declare -A h=();
Hash h;
h=(
 ["name"]="Shigeo NISHIDA"
 ["age"]=51
 ["pref"]=Kochi
 ["sex"]=male
);

h.dump;

echo h.length;
h.length;

echo h.foreach echo;
h.foreach echo;

echo h.exists 51;
h.exists 51;
echo $?

echo h.exists xKochi;
h.exists xKochi;
echo $?

echo h.keys;
h.keys;

echo h.key_exists name;
h.key_exists name;
echo $?

echo h.key_exists xname;
h.key_exists xname;
echo $?

echo delete h;
delete h;

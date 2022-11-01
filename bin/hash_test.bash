#! /bin/bash 
#
# hash_test.bash -- 
#
#
set -u;
progname=$(basename ${0});
progdir=$(cd "`dirname $0`" && pwd);
progargs=$@;

# モジュールの初期化
top_dir=$(dirname ${progdir});
modules_dir="${top_dir}/modules";
source "${modules_dir}/setup.sh";

# 使用クラスの宣言
use -s Hash;

echo Hash h;
echo Hash h2;
declare -A h=(
 ["name"]='Shigeo NISHIDA'
 ["age"]=51
 ["Country"]=Japan
 ["pref"]=Kochi
 ["sex"]=male
);

declare -p h;
declare -A h2;
declare -A h3;
Hash h;
Hash h2;


declare -p h | sed -e 's/^[^=].=//';

echo h.serialize;
h.serialize;

h2 := h;

echo Hash h3;
Hash h3 := h;

echo Hash h3;
Hash h4 = h;

dump h;
dump h2;
dump h3;
dump h4;

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

delete h h2 h3;

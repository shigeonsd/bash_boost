#! /bin/bash 
#
# hash_test.bash -- 
#
#
set -u;
source "$(cd $(dirname "$0") && pwd)/../bash-boost.bash";

# 使用クラスの宣言
use Hash;

echo Hash h;
echo Hash h2;
declare -A h=(
 ["name"]='Shigeo NISHIDA'
 ["age"]=51
 ["country"]=Japan
 ["pref"]=Kochi
 ["sex"]=male
);

declare -p h;
declare -A h2;
declare -A h3;
Hash h;
Hash h2;


#declare -p h | sed -e 's/^[^=].=//';

echo h.serialize;
h.serialize;

h2 := h;

echo Hash h3;
Hash h3 := h;

echo Hash h3;
Hash h4 = h;

#dump h;
#dump h2;
#dump h3;
#dump h4;

echo h.length;
h.length;

echo h.map echo;
h.map echo;

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

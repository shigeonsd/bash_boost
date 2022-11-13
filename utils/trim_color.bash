#! /bin/bash
#
# trim_color.bash -- エスケープシーケンス削除
#
#
set -u;
sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"

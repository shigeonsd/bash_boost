#! /bin/bash
#
# usage.bash -- usage.bash の使用例
#
set -u;
progname=$(basename ${0});
progdir=$(cd "`dirname $0`" && pwd);
progargs=("$@");

funcs_dir="${progdir}/../funcs";
source ${funcs_dir}/VARS;
source ${funcs_dir}/FILES;
source "${funcs_dir}/extra/usage.bash";

function __getopt1() {
    local opt="${1}";
    local optarg="${2-null}";

    case "${opt}" in 
    -x|--exclude) echo "x:${opt}";                    ;;
      -y|--yield) echo "y:${opt} optarg='${optarg}'"; ;;
              -z) echo "z:${opt}";                    ;;
       -q|--quit) echo "q:${opt}";                    ;;
               *) die "$(__ unknown_option ${opt})";  ;;
    esac
}

function __getopt2() {
    echo "opt2:args=$@";
}

usage_def "-x|--exclude" "-y=NUM|--yield=NUN" "-z" "-q|--quit" "FILE1 FILE2" <<_
    ここに使い方の詳細を書くこと。
    複数行記載できる。
    さらに詳しく.
_
usage_chkopt ge 2;
usage_getopt #__getopt1 __getopt2

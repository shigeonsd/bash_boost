#! /bin/bash
#
# usage.bash -- usage.bash の使用例
#
set -u;
source "$(cd $(dirname "$0") && pwd)/../../bash-boost.bash";

function __getopt1() {
    local opt="${1}";
    local optarg="${2-null}";

    case "${opt}" in 
    -x|--exclude) echo "opt1: opt=${opt}";                    ;;
      -y|--yield) echo "opt1: opt=${opt} optarg='${optarg}'"; ;;
              -z) echo "opt1: opt=${opt}";                    ;;
      -q|--quiet) echo "opt1: opt=${opt}";                    ;;
               *) die "$(__ unknown_option ${opt})";  ;;
    esac
}

function __getopt2() {
    echo "opt2: args=($@), num=$#";
    local arg;
    local i=1;
    for arg in "$@"; do
	echo "args[${i}]='$arg'";
	((i++));
    done
    required_args $# -eq 2;
}

usage "-x|--exclude" "-y=NUM|--yield=NUN" "-z" "-q|--quit" "FILE1 FILE2" <<_
    ここに使い方の詳細を書くこと。
    複数行記載できる。
    さらに詳しく.
_
#usage_chkopt ge 2;
usage_getopt __getopt1 __getopt2

function main() {
    -enter;
    info "args=$@";
    info "processing main.";
    -leave;
}

run main "$@";

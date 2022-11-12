#! /bin/bash
#
# usage.sh -- コマンドラインオプションに関する定義
#
declare -g __usage_description="";
declare -g -a __usage_opt1=();
declare -g -a __usage_opt2=();

function __usage_defopt1() {
    local arg;
    for arg in "$@"; do
	[[ "${arg}" =~ ^- ]] || continue;
	__usage_opt1+=(${arg});
    done;
}

function __usage_defopt2() {
    local arg;
    for arg in "$@"; do
	[[ "${arg}" =~ ^- ]] && continue;
	__usage_opt2+=(${arg});
    done;
}

function __usage_defdesc() {
    __usage_description="$(cat)";
}

function __fmt_opt1() {
    local opt;
    local delm="";
    for opt in ${__usage_opt1[@]}; do
	echo -n "${delm}[${opt}]"
	delm=" ";
    done;
}

function __fmt_opt2() {
    local opt;
    local delm="";
    for opt in ${__usage_opt2[@]}; do
	echo -n "${delm}${opt}"
	delm=" ";
    done;
}

function usage() {
    echo "Usage: ${progname} " "$(__fmt_opt1)" "$(__fmt_opt2)";
    echo "${__usage_description}";
    exit 0;
}

function usage.def() {
    __usage_defopt1 "$@";
    __usage_defopt2 "$@";
    __usage_defdesc "$@";
}

function __usage_valid_opt() {
    local opt;
    for opt in  ${progargs[@]}; do
	
	echo opt=$opt;
    done;
}

function usage.chkopt() {
    local arg1=$1;
    local arg2=${2-null};
    local num;
    local ope;

    case $# in
    1) num=${arg1}; ope="-eq";     ;;
    2) num=${arg2}; ope="${arg1}"; ;;
    esac

    [ ${#progargs[@]} $ope $num ] || usage;
}

function __usage_cmpopt() {
    local arg="${1}";
    local opt="${2}";
    local o;
    [ ${arg} = ${opt} ] && return 0;
    for o in $(echo ${opt} | sed -e 's/|/ /g'); do
	[ ${arg} = ${o} ] && return 0;
    done;
    return 1;
}

function usage.getopt() {
    local arg;
    local opt;
    for arg in  ${progargs[@]}; do
	for opt in ${__usage_opt1[@]}; do
	    __usage_cmpopt "${arg}" "${opt}" && {
		echo ${arg};
		continue 2;
	    }
	done;
	die "$(__ unknown_option "${arg}")"
    done;
}

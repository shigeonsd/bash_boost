#! /bin/bash
#
# usage.sh -- コマンドラインオプションに関する定義
#
declare -g __usage_description="";
declare -g -a __usage_opt1=( "-h|--help" );
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

function usage_def() {
    __usage_defopt1 "$@";
    __usage_defopt2 "$@";
    __usage_defdesc "$@";
}

function usage_chkopt() {
    local arg1=$1;
    local arg2=${2-null};
    local num;
    local ope;

    case $# in
    1) num=${arg1}; ope="-eq";     ;;
    2) num=${arg2}; ope="${arg1}"; ;;
    esac

    [ "${#progargs[@]}" "-${ope}" "${num}" ] || usage;
}

function __equal_opt() {
    local arg="${1}";
    local opt="${2}";

    # -x=xxxx 形式か？
    [[ ${opt} =~ ^-.*=.*$ ]] || return 1;
    local _arg=$(echo "${arg}" | sed -e 's/=.*$//');
    local _opt=$(echo "${opt}" | sed -e 's/=.*$//');
    [ "${_arg}" = "${_opt}" ];
}

function __usage_cmpopt() {
    local arg="${1}";
    local opt="${2}";
    local o;
    [ "${arg}" = "${opt}" ] && return 0;
    for o in $(echo "${opt}" | sed -e 's/|/ /g'); do
	[ "${arg}" = "${o}" ] && return 0;
	__equal_opt "${arg}" "${o}" && return 0;
    done;
    return 1;
}

function __get_optstr() {
    echo "${1}" | sed -e 's/=.*$//';
}

function __get_optarg() {
    echo "${1}" | sed -e 's/^.*=//';
}

function usage_getopt() {
    local lambda1="${1-:}";
    local lambda2="${2-:}";
    local arg;
    local opt1;
    local opt2=();
    for arg in  "${progargs[@]}"; do
	case "${arg}" in
	-h|--help) usage; ;;
	esac
	[[ "${arg}" =~ ^- ]] || {
	    opt2+=("${arg}");
	    continue;
	}
	for opt1 in "${__usage_opt1[@]}"; do
	    __usage_cmpopt "${arg}" "${opt1}" && {
		local    opt="$(__get_optstr "${arg}")";
		local optarg="$(__get_optarg "${arg}")";
		"${lambda1}" "${opt}" "${optarg}";
		continue 2;
	    }
	done;
	die "$(__ unknown_option "${arg}")";
    done;
    "${lambda2}" "${opt2[@]}";
}


#! /bin/bash
#
# usage.sh -- コマンドラインオプションに関する定義
#
defun __usage_info  mod_info;
defun __usage_debug mod_debug;

declare -A __options;
__usage_options_2="";
function __usage_option_2() {
    local opts=$1;
    local func=$2;

    __usage_options_2="${__usage_options_2} [${opts}]";
    for opt in $(echo $opts | sed -e 's/|/ /g'); do
	__options["${opt}"]="${func}";
    done;
}

__usage_options_1="";
function __usage_option_1() {
    __usage_options_1="${__usage_options_1} $@";
}

function usage_option() {
    local num=2;
    [ $# -eq 1 ] && {
	num=1;
    }
    __usage_option_${num} $@;
}

__usage_description="
    ここに使い方の詳細を書くこと。
    複数行記載できる。
    さらに詳しく.
";
function usage_description() {
    local desc="${1}";
    __usage_description="${desc}";
}

function parse_option() {
    local array_keys="${!__options[@]}";

    for arg in ${progargs}; do
	[ "$arg" = "--"  ] && break;
	[[ "$arg" =~ ^- ]] || break;
	array_exists ${arg} "${array_keys}" || die "Known option $arg.";
	"${__options[$arg]}";
    done
}

function usage() {
    printf "Usage: ${progname} ${__usage_options_2}${__usage_options_1}${__usage_description}";
    exit 0;
}

function usage_if_no_option() {
    [ ${#progargs[@]} -eq 0 ] && { usage; }
}

function usage_if_args_ne() {
    local n="${1}";
    [ ${#progargs[@]} -ne ${n} ] && { usage; }
}

function usage_if_args_ne_1() {
    usage_if_args_ne 1;
}

function usage_if_args_ne_2() {
    usage_if_args_ne 2;
}

function __usage_if_not_0_args() {
    [ $# -ne ${___n} ] && { usage; }
}

usage_option "-h|-help|--help" usage;

#! /bin/bash
#
# options.sh -- コマンドラインオプションに関する定義
#
function __options_info() {
    mod_info "${BASH_SOURCE[0]}" $@;
}

declare -A __options;
__usage_options_2="";
function __def_option_2() {
    local opts=$1;
    local func=$2;

    __usage_options_2="${__usage_options_2} [${opts}]";
    for opt in $(echo $opts | sed -e 's/|/ /g'); do
	__options["${opt}"]="${func}";
    done;
}
__usage_options_1="";
function __def_option_1() {
    __usage_options_1="${__usage_options_1} $@";
}

function def_option() {
    local num=2;
    [ $# -eq 1 ] && {
	num=1;
    }
    __def_option_${num} $@;
}

__usage_description="
    ここに使い方の詳細を書くこと。
    複数行記載できる。
    さらに詳しく.
";
function def_description() {
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
    [ "${progargs}" = "" ] && { usage; }
}

def_option "-h|-help|--help" usage;

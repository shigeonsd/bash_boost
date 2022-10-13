#! /bin/bash
#
# options.sh -- コマンドラインオプションに関する定義
#
function __options_info() {
    mod_info "${BASH_SOURCE[0]}" $@;
}

#__options=();
declare -A __options;
function def_option() {
    local opts=$1;
    local func=$2;
    for opt in $(echo $opts | sed -e 's/|/ /g'); do
	__options["${opt}"]="${func}";
    done;
}

function parse_options() {
    if_debug && {
	echo "${!__options[@]}";
	echo "${__options[@]}";
    }
}

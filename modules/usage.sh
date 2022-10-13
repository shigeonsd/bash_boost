#! /bin/bash
#
# usage.sh --
#
usage_options="${usage_options-[run]}";
usage_description=${usage_description-"
"};
function _usage() {
    printf "Usage: ${progname} [-h|-help|--help|help] ${usage_options}${usage_description}";
    exit 0;
}

[ $# -eq 0 ] && { _usage; }
#case $1 in
#-h|-help|--help|help) _usage; ;;
#*)       ;;
#esac

def_option "-h|-help|--help|help" _usage;

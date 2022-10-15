#! /bin/bash
#
# usage.sh --
#
usage_options="${usage_options-[run]}";
usage_description=${usage_description-"
"};
function usage() {
    printf "Usage: ${progname} [-h|-help|--help|help] ${usage_options}${usage_description}";
    exit 0;
}

function usage_if_no_option() {
    [ "${progargs}" = "" ] && { usage; }
}

def_option "-h|-help|--help|help" usage;

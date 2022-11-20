#! /bin/bash
#
# if.bash -- if 支援関数
#

function if_debug() {
    [[ -v DEBUG ]] || return 1;
    case $DEBUG in
    0|true)  return 0; ;;
    1|false) return 1; ;;
    esac
    return 1;
}

function if_true() {
    local var="${1}";
    declare -n ref="${1}";
    [[ -v "${var}" ]] || return 1;
    case "${ref}" in
    0|true)  return 0; ;;
    1|false) return 1; ;;
    esac
    return 1;
}


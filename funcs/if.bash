#! /bin/bash
#
# if.sh -- if 支援関数
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
    [[ -v "${var}" ]] || return 1;
    case $(eval echo "\$${var}") in
    0|true)  return 0; ;;
    1|false) return 1; ;;
    esac
    return 1;
}

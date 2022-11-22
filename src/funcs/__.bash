#! /bin/bash
#
# msg_catalog.sh -- メッセージカタログ
#
function __() {
    local key=$1;
    shift;
    hash_key_exists __messages "${key}" \
	|| die "${key}: Undefined message in \$__messages[@].";
    eval "echo $(echo "${__messages[$key]}")";
}

declare -g -A __messages=(
    [invalid_arguments]='$@: Invalid arguments.'
       [unknown_option]='$1: Unknown option.'
);

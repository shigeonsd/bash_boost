#! /bin/bash
#
# msg_catalog.sh -- メッセージカタログ
#
function __() {
    local key=$1;
    shift;
    hash_key_exists __messages "${key}" \
	|| die "${key}: Undefined message in \$__messages[@].";
    local msg="${__messages[$key]}";
    #eval "echo $(echo "${__messages[$key]}")";
    echo "$@: ${msg}";
}

declare -g -A __messages=(
         [invalid_arguments]='Invalid argument(s).'
            [unknown_option]='Unknown option.'
            [file_not_found]='File not found.'
 [no_such_file_or_directory]='No such file or directory.'
);

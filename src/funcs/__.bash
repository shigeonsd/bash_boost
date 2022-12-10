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
             [invalid_value]='Invalid value.'
            [unknown_option]='Unknown option.'
            [file_not_found]='File not found.'
 [no_such_file_or_directory]='No such file or directory.'
                    [failed]='Failed function or command.'
               [failed_pipe]='Failed pipe.'
               [not_boolean]='Not boolean.'
                 [not_digit]='Not digit.'
           [not_implemented]='Not implemented.'
          [caught_exception]='Caught exception.'
);

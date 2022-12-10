#! /bin/bash
#
# if.bash -- if 支援関数
#

function __boolean() {
    local val="${1}";
    case "${val}" in
    false|FALSE) return 1; ;;
              *) return 0; ;;
    esac
    die "$(__ not_boolean "${val}")";
}

function if_debug() {
    [[ -v DEBUG ]] || return 1;
    is_boolean DEBUG && {
	__boolean "${DEBUG}";
	return $?;
    }
    is_digit DEBUG && {
	[ "${DEBUG}" -ne 0 ];
	return $?;
    }
    die "$(__ invalid_value "${DEBUG}")";
}

function if_true() {
    local val="${1}";
    [[ -v "${val}" ]] && {
	declare -n ref="${1}";
	is_digit "${val}" && {
	    [ "${ref}" -ne 0 ];
	    return $?
	}
	__boolean "${ref}";
	return $?
    }
    is_digit val && {
	[ "${val}" -ne 0 ];
	return $?
    }
    __boolean "${val}";
    return $?
}


#! /bin/bash
#
# array.sh -- Array クラス
#
#
function Array() {
#    _extends Object $@;
    local ___this="$1";
    local ___class=${FUNCNAME};
    local ___props=(
	aaa
	bbb
	ccc
    );
    local ___methods=(
	push
	pop
	length
	foreach
#	shift
#	unshift
	exists
	key_exists
	keys
	clear
	reverse
    );
    shift;
    declare -a ${___this};
    _new;
    eval "${___this}=($@)";
}

function Array.push() {
    THIS+=($1);
}

function Array.pop() {
    local len=${#THIS[@]};
    local n=$((len -1));
    echo  ${THIS[$n]};
    unset THIS[$n];
    THIS=(${THIS[@]});
}

function Array.length() {
    echo ${#THIS[@]};
}

function Array.foreach() {
    local func="${1}";
    for e in ${THIS[@]}; do
	${func} $e || return $?;
    done;
    return 0;
}

function Array.keys() {
    echo ${!THIS[@]};
}

function Array.clear() {
    unset THIS[@];
}

function Array.exists() {
    local val="$1";
    for e in ${THIS[@]}; do
        [ "${e}" == "${val}" ] && return 0;
    done;
    return 1;
}

function Array.key_exists() {
    local key="$1";
    for e in ${!THIS[@]}; do
        [ "${e}" == "${key}" ] &&  return 0;
    done;
    return 1;
}

function Array.reverse() {
    for e in ${THIS[@]}; do
        echo "${e}";
    done \
    | tac \
    | while read elm ; do
	echo "${elm}";
    done
}

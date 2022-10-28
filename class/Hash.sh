#! /bin/bash
#
# Hash.sh -- Hash クラス
#
#
function Hash() {
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
	shift
	unshift
	exists
	key_exists
	keys
	clear
	reverse
    );
    shift;
    _new;
    eval "${___this}=($@)";
}

function Hash.push() {
    THIS+=($1);
}

function Hash.pop() {
    local len=${#THIS[@]};
    local n=$((len -1));
    echo  ${THIS[$n]};
    unset THIS[$n];
    THIS=(${THIS[@]});
}

function Hash.unshift() {
    local _array=($1);
    _array+=(${THIS[@]});
    THIS=(${_array[@]});
}

function Hash.shift() {
    local len=${#THIS[@]};
    echo  ${THIS[0]};
    unset THIS[0];
    THIS=(${THIS[@]});
}

function Hash.length() {
    echo ${#THIS[@]};
}

function Hash.foreach() {
    local func="${1}";
    echo ${THIS[@]};
    for e in ${THIS[@]}; do
	${func} $e || return $?;
    done;
    return 0;
}

function Hash.keys() {
    echo ${!THIS[@]};
}

function Hash.clear() {
    THIS=();
}

function Hash.exists() {
    local val="$1";
    for e in ${THIS[@]}; do
        [ "${e}" == "${val}" ] && return 0;
    done;
    return 1;
}

function Hash.key_exists() {
    local key="$1";
    for e in ${!THIS[@]}; do
        [ "${e}" == "${key}" ] &&  return 0;
    done;
    return 1;
}

function Hash.reverse() {
    for e in ${THIS[@]}; do
        echo "${e}";
    done \
    | tac \
    | while read elm ; do
	echo "${elm}";
    done
}

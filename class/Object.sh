#! /bin/bash
#
# Object.sh -- Object クラス
#
#

# Constructor
function Object() {
    local ___super=null;
    local ___class=${FUNCNAME};
    local ___this="$1";
    shift;

    public aaa a;
    public bbb b;
    public ccc c;

    _new;
}

function Object.operator_=() {
    local arg1="${1}";

    [ $# -eq 0 ] && return;

    # オブジェクの代入
    # var = @varname 
    [[ ${arg1} =~ ^@ ]] && {
	local varname=$(echo "${arg1}" | sed -e 's/^@//');
	clone ${varname} THIS;
	return;
    }

    # 配列/連想配列の代入
    # var = [ e0, e1, e2, ... ];
    # var = [ [k0]=e0, [k1]=e1, [k2]=e2, ... ];
    [[ ${arg1} =~ ^\[ ]] && {
	echo array cp
	echo $@;
	echo $*;

	eval "THIS=$(echo "$*" | sed -e 's/^\[/(/' -e 's/\]$/)/')";
	declare -p THIS;
	return;
    }
    
    # 値の代入
    THIS="$@";
}

function Object.operator_:=() {
    local arg1="${1}";

    [ $# -eq 0 ] && return;

    local varname=$(echo "${arg1}" | sed -e 's/^@//');
    clone ${varname} THIS;
    return;
}

#! /bin/bash 
#
# cmt2json.bash -- lib 配下のファイルに記載されているコメントを json 形式で取り出す
#
set -u;

# 使用方法を記載する。
# usage() で使用する。
usage_options="sh_files...";
usage_description="
    lib 配下のファイルに記載されているコメントを指定された形式で取り出す。
";

_no_log_=true;
source ../lib/toolkit.sh

function _get_var_docs()      { _get_docs "variable" $@; }
function _get_func_docs()     { _get_docs "function" $@; }

function _begin() { echo "{"; }
function _end()   { echo "}"; }

function _serialize() {
    local key="${1}";
    awk -v key="${key}" '
BEGIN {
    comma0 = "";
}
/^function:/ || /^variable:/{
    doc["name"] = $2;
    next;
}
/^.*:/ {
    label = $1;
    gsub(":", "", $1);
    key = $1;
    gsub(label, "", $0);
    doc[key] = $0;
    next;
}
/description:/ {
    doc["description"]=$2;
    next
}
/^$/ {
    printf("%s{\n", comma0);
    comma1="";
    for (k in doc) {
	#print(k);
	#print(doc[k]);
	printf("%s\"%s\" : \"%s\"\n", comma1, k, doc[k]);
	comma1=",";
    }
    printf("}\n");
    comma0 = ",";

    for (k in doc) {
	doc[k] = "";
    }
}
'
}

function _get_doc() {
    local key="${1}";
    local file="${2}";

    cat "${file}" \
        | sed -e '/^##/p' -e 'd' \
        | sed -e 's/^##[ \t]*//' \
        | awk "/${key}:/, /^$/ { print; }" \
        | _serialize "${key}";
}

_comma1="";
function _get_docs() {
    local key="$1";
    shift;
    echo "${_comma1}\"${key}s\" : ["
    for f in $@; do
        _get_doc "${key}" "$f";
    done
    echo ']'
    _comma1=",";
}

_begin;
_get_var_docs  $@;
_get_func_docs $@;
_end;

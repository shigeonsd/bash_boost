#! /bin/bash 
#
# describe.bash -- 関数定義抽出
#
set -u;
source "$(cd $(dirname "$0") && pwd)/../bash-boost.bash";

function __getopt2() {
    exist_file "${1}" || die $(__ file_not_found "${1}");
}

usage "bash_file" <<_
    引数で指定された bash ファイルから関数定義を抽出する。
    Public function:  関数名が '_' 以外で始まる関数
    Protected function:  関数名が '_' で始まる関数
    Private function:  関数名が '__' で始まる関数
_
usage_chkopt eq 1;
usage_getopt : __getopt2;

function _indent() {
    sed -e 's/^/    /';
}

function _trim() {
    awk '{ print $2; }';
}

function _format() {
    _trim | _indent;
}

function __module_name() {
    local module_name=$(basename $1 | sed -e 's/\..*$//');
    echo "Module name:"
    echo "${module_name}" | _indent;
}

function __public_func() {
    echo "Public functions:"
    grep '^function [^_]' $1 | _format; 
}

function __protected_func() {
    echo "Protected functions:"
    grep '^function _[^_]' $1 | _format; 
}

function __private_func() {
    echo "Private functions:"
    grep '^function __[^_]' $1  | _format;
}

function main() {
    __module_name "${bash_file}";
    __public_func "${bash_file}";
    __protected_func "${bash_file}";
    __private_func "${bash_file}";
}

local bash_file="${1}";
main "${bash_file}";

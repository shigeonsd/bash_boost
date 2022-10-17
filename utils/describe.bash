#! /bin/bash 
#
# describe.bash -- 関数定義抽出
#
set -u;
progname=$(basename ${0});
progdir=$(cd "`dirname $0`"; pwd);
progargs=$@

top_dir=$(dirname ${progdir});
modules_dir="${top_dir}/modules";
source "${modules_dir}/options.sh"

# 使用方法を記載する。
# usage() で使用する。
usage_option "bashfile";
usage_description "
    引数で指定された bash ファイルから関数定義を抽出する。
    Public function:  関数名が '_' 以外で始まる関数
    Protected function:  関数名が '_' で始まる関数
    Private function:  関数名が '__' で始まる関数
";

# コマンドラインオプションの定義
usage_if_no_option;  # オプションが指定されていなければ usage を表示する
parse_option;        # コマンドラインオプションの解析

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
    __module_name $1;
    __public_func $1;
    __protected_func $1;
    __private_func $1;
}

main $1;

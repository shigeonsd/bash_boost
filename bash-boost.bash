#! /bin/bash
set -u;

top_dir=${BASH_BOOST_DIR:-"$(dirname "${BAS_SOURCE[0]}")"};

source "${top_dir}/funcs/bootstrap";

# 拡張機能読み込み
#
require       \
    __        \
    array     \
    debug     \
    date      \
    defun     \
    required  \
    file      \
    misc      \
#

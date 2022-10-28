#! /bin/bash
#
# defvar.sh -- 変数定義
#
progname=$(basename ${0});
progdir=$(cd "`dirname $0`" && pwd);
progargs=$@;

top_dir=$(dirname ${progdir});
modules_dir="${top_dir}/modules";
class_dir="${top_dir}/class";

log_dir="${top_dir}/log";
doc_dir="${top_dir}/doc";

hostname=$(hostname);
_hostname=$(hostname | sed -e 's/-/_/g');


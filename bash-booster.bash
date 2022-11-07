#! /bin/bash
#
# bash-booster.sh -- 
#
set -u

progname=$(basename ${0});
 progdir=$(cd "`dirname $0`" && pwd);
progargs=($@);

        top_dir=$(dirname ${progdir});
      funcs_dir="${top_dir}/funcs";
extra_funcs_dir="${funcs_dir}/extra";
    modules_dir="${top_dir}/modules";
      class_dir="${top_dir}/class";
        log_dir="${top_dir}/log";
       docs_dir="${top_dir}/docs";

hostname=$(hostname);
_hostname=$(hostname | sed -e 's/-/_/g');

source \
    ${funcs_dir}/array.sh    \
    ${funcs_dir}/date.sh     \
    ${funcs_dir}/debug.sh    \
    ${funcs_dir}/defun.sh    \
    ${funcs_dir}/exists.sh   \
    ${funcs_dir}/file.sh     \
    ${funcs_dir}/if.sh       \
    ${funcs_dir}/log.sh      \
    ${funcs_dir}/misc.sh     \
    ${funcs_dir}/required.sh \
    ;

source \
    ${extra_funcs_dir}/usage.sh \
    ${extra_funcs_dir}/load.sh  \
    ${extra_funcs_dir}/class.sh \
    ${extra_funcs_dir}/aop.sh   \
    ;

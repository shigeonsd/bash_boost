#! /bin/bash
#
# setup.sh -- モジュールを使用するための準備
#
set -u
source "${modules_dir}/vars.sh";
source "${modules_dir}/core.sh";

source "${modules_dir}/defun.sh";
source "${modules_dir}/log.sh";
source "${modules_dir}/debug.sh";
source "${modules_dir}/date.sh";
source "${modules_dir}/usage.sh";
source "${modules_dir}/load.sh";
source "${modules_dir}/class.sh";
source "${modules_dir}/aop.sh";

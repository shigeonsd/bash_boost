#! /bin/bash
#
# try_catch.bash -- 
#
set -u;
source "$(cd $(dirname "$0") && pwd)/../../bash-boost.bash";
#require preprocessor
function exception() {
    _e=( "$@" );
}

#@preprocessor func1
function func1() {
    declare -a _e=(); while true; do
    {
	-check_point;
	exception "Unknown exception";
	break;
	-check_point;
    }
    break; done; array_empty exception ||
    {
	-check_point;
	echo "_e=( ${_e[@]} )";
    }
    #finally
    {
	-check_point;
    }
    return 0;
}

function main() {
    -enter
    declare -f func1
    func1;
    -leave
}

run main "$@";

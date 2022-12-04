#! /bin/bash
#
# try_catch.bash -- 
#
set -u;
source "$(cd $(dirname "$0") && pwd)/../../bash-boost.bash";
require defun;
require preprocessor;

@preprocess func1
function func1() {
    local array=($(seq 1 8));
    -enter;
    ---
    array_map array lambda
	{
	    -enter;
	    local a1="${1}";
	    local a2="${2}";
	    try
	    {
		echo "$(-indent)[${a2}]=${a1}";
		exception "no error";
		throw;
	    }
	    catch
	    {
		echo "$(-indent)catch_block";
	    }
	    finally
	    {
		echo "$(-indent)finally_block";
	    }
	    -leave;
	    return 0;
	}
    
    ---
    try
    {
	local array_s=($(ls -1));
	array_map array_s lambda
	{
	    -enter;
	    local a1="${1}";
	    local a2="${2}";
	    {
		echo "$(-indent)[${a2}]=${a1}";
	    }
	    -leave;
	    return 0;
	}
    }
    catch
    {
	echo "$(-indent)### catch_block";
    }
    finally
    {
	echo "$(-indent)### finally_block";
    }
    ---
    -leave;
    return 0;
}

function main() {
    -enter
    declare -f func1
    func1;
    -leave
}

run main "$@";

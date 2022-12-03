#! /bin/bash
#
# try_catch.bash -- 
#
set -u;
source "$(cd $(dirname "$0") && pwd)/../../bash-boost.bash";
require preprocessor;

@preprocessor func1
function func1() {
    try
    {
	echo "### TRY ###";
	try
	{
	    echo "### TRY 2###";
	    exception "Unknown exception: TRY 2";
	    throw;
	}
	catch
	{
	    echo "### CATCH 2 ###";
	    echo "${exception[@]}";
	}
	finally
	{
	    echo "### FINALLY 2 ###";
	}
    }
    catch
    {
	echo "### CATCH ###";
	echo "${exception[@]}";
    }
    finally
    {
	echo "### FINALLY ###";
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

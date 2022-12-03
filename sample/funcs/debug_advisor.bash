#! /bin/bash
#
# debug_advice.bash -- 
#
#
require debug;

@Before          debug 'func1' 'func3' 
@After           debug 'func1' 'func3'
@Around          debug 'func2'
@After_returning debug '^func.*' 

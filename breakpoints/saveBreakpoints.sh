#!/usr/bin/env bash

# update
# this feature can be a time saver when debugging a complex issue;

# note: use source command to load the text file back (not load)

# note 2: use set confirm off to turn off prompt if I want to automatically delete all the existing breakpoints

# note 3: I can put # comment lines in the breakpoint text file; this can be useful when I want to disable/enable some callbacks

function setUp() {
    sutSrc="$( dirname ${0} )/$( basename ${0%.sh} ).cpp"
    sutBin="/tmp/$( basename ${0%.sh} ).o"
    if ! ( g++ -g -std=c++17 -o ${sutBin} ${sutSrc} )
    then
        echo "fail to compile"
        exit 1
    fi
}

function run() {
    gdb ${sutBin} -batch \
-ex "b saveBreakpoints.cpp:13" \
-ex "b saveBreakpoints.cpp:19" \
-ex "save breakpoints /tmp/saveBreakpoints.bp"
    
    cat /tmp/saveBreakpoints.bp
    
    gdb ${sutBin} -batch \
-ex "source /tmp/saveBreakpoints.bp" \
-ex 'i br' \
-ex 'set confirm off' \
-ex 'd br' \
-ex 'source /tmp/saveBreakpoints.bp' \
-ex 'i br'

}

setUp
run

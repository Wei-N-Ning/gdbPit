#!/usr/bin/env bash

# source: wkou
# search: Gem #119 GDB Scripting

set -e
CC=${CC-gcc}
CXX=${CXX-g++}
DBG=${DBG-gdb}
TEMPDIR=/tmp/sut

tearDown() {
    rm -rf ${TEMPDIR} /tmp/_ /tmp/_.* /tmp/__*
}

setUp() {
    tearDown
    mkdir -p ${TEMPDIR}
}

buildSUT() {
    ${CXX} -std=c++14 -g -ggdb3 ./preload_subroutine.cpp -o ${TEMPDIR}/_
}

# note in the original version I had quite a few if-else logic in the
# command to traverse deeper into the object graph:

#    set $eval = evaluator().get()
#    if $eval != 0
#        print $eval->key()
#        set $graph = $eval->graph()
#        print "@@@@ graph:"
#        if $graph != 0
#            print $graph->name()
#        else
#            print "____"
#        end
#    else
#        print "____"
#    end
createGDBScript() {

    cat >${TEMPDIR}/command.txt << "EOF"
define inspectall
    print "//// process:"
    print id().value()
    print "#### evaluator:"
    print &evaluator()
end
start
break preload_subroutine.cpp:95
commands 2
inspectall
continue
end
continue
EOF
}

preload_script() {
    gdb -batch -command=${TEMPDIR}/command.txt ${TEMPDIR}/_
}

setUp
buildSUT
createGDBScript
preload_script


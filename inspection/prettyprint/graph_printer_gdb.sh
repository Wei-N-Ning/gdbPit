#!/usr/bin/env bash

# source:
# http://tromey.com/blog/?p=524
# https://www.rethinkdb.com/blog/make-debugging-easier-with-custom-pretty-printers/

# 1) the source code shows a mock-up version of a graph-based computing
#    network that has a flaw causing segfault (documented in source);
#    the developer wants to debug this flaw by stopping the program at
#    each call to the compute() method of the Node object; he then
#    may take advantage of the pretty-print feature implemented in
#    python to inspect the data and track down the offending code;
# 2) this script builds the program and automates the loading and running
#    of SUT in gdb.
# 3) note GDB must "see" the python script therefore PYTHONPATH is
#    modify to enable that; in an environment with a package/shell management
#    system this can be configured in the package or payload
# 4) the GDB command can also be written in a script file that is set up
#    automatically by the environment management system.

CC=${CC-gcc}
CXX=${CXX-g++}
DBG=${DBG-gdb}

set -e

TEMPDIR=/tmp/sut

tearDown() {
    rm -rf ${TEMPDIR} /tmp/_ /tmp/_.* /tmp/__*
}

setUp() {
    tearDown
    mkdir -p ${TEMPDIR}
}

# $1: additional cxxflags
sutbin=
buildSUT() {
    ${CXX} -std=c++14 ${1} -o ${TEMPDIR}/_ ./graph.cpp
    sutbin=${TEMPDIR}/_
}

modulePath=$( realpath ./graph_printer.py )
modulePath=$( dirname ${modulePath} )
moduleName=simple_printer
export PYTHONPATH=${modulePath}:${PYTHONPATH}

# to show the raw data structure contents:
# print /r g
# note that core::graph::Graph (g) is printed by the new printer
# ::Graph (phony) is still printed by the default printer
debugSUT() {
    cat >${TEMPDIR}/commands.gdb <<"EOF"
py import graph_printer_gdb
py graph_printer_gdb.init()
start
n 3
print g
print phony
quit
EOF
    ${DBG} -batch -command=${TEMPDIR}/commands.gdb ${sutbin}
}

setUp
buildSUT "-g"
debugSUT
tearDown

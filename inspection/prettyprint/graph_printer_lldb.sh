#!/usr/bin/env bash

# source:
# https://lldb.llvm.org/python-reference.html
# good read: https://lldb.llvm.org/scripting.html
# https://lldb.llvm.org/python_reference/index.html

# CHECK THIS OUT!!!
# https://github.com/llvm-mirror/lldb/tree/master/examples/python
# https://github.com/tgebarowski/lldb-scripts


CC=${CC-gcc}
CXX=${CXX-g++}
DBG=${DBG-lldb}

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
    ${CXX} ${1} -std=c++14 -o ${TEMPDIR}/_ ./graph.cpp
    sutbin=${TEMPDIR}/_
}

modulePath=$( realpath ./graph_printer_lldb.py )
modulePath=$( dirname ${modulePath} )
moduleName=graph_printer_lldb
export PYTHONPATH=${modulePath}:${PYTHONPATH}

# lldb -- /tmp/sut/_
# proc la -s
# script import graph_printer_lldb
# br s -n processGraph
# c
# script g = lldb.frame.FindVariable("g")
# script graph_printer_lldb.print_graph(g)
debugSUT() {
    :
}

setUp
buildSUT "-g"
debugSUT
#tearDown



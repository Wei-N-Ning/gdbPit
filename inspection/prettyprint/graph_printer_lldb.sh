#!/usr/bin/env bash

# NOTE
# this example shows the power of LLDB Python API:
# its syntax and support of object graph inspection is better than
# GDB's
# I like the fact that it has one class for each low level construct
# there are examples in LLVM repo (see below)
# I copied some code to graph_printer_lldb.py
# this should be able to get me started at work...
# run this script, then I should see "m_params" instance property is
# inspected per call to the compute() method which crashes due to a
# deliberate flaw.

# source:
# https://lldb.llvm.org/python-reference.html
# good read: https://lldb.llvm.org/scripting.html
# https://lldb.llvm.org/python_reference/index.html

# CHECK THIS OUT!!!
# https://github.com/llvm-mirror/lldb/tree/master/examples/python
# --> how to quuery SBValue properties:
#     https://github.com/llvm-mirror/lldb/blob/master/examples/python/sbvalue.py
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
# //// OR ////
# b main
# pr la
# (this is equivalent to GDB's start, because I won't run main twice)

# script import graph_printer_lldb
# br s -n processGraph
# c
# script g = lldb.frame.FindVariable("g")
# script graph_printer_lldb.print_graph(g)
debugSUT() {
    cat >${TEMPDIR}/commands.lldb <<EOF
br set -n core::Node::compute
script import graph_printer_lldb
br command add 1.1
script graph_printer_lldb.print_params()
continue
DONE
pr la
EOF
    ${DBG} \
--batch \
-s ${TEMPDIR}/commands.lldb \
-- ${sutbin}
}

setUp
buildSUT "-g"
debugSUT
tearDown

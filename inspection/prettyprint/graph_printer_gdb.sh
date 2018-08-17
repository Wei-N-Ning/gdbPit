#!/usr/bin/env bash

# source:
# http://tromey.com/blog/?p=524
# https://www.rethinkdb.com/blog/make-debugging-easier-with-custom-pretty-printers/

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
c
EOF
    ${DBG} -batch -command=${TEMPDIR}/commands.gdb ${sutbin}
}

setUp
buildSUT "-g"
debugSUT
tearDown

#!/usr/bin/env bash

# source
# https://lldb.llvm.org/python-reference.html

CC=${CC-clang}
CXX=${CXX-clang++}
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

sutbin=
buildSUT() {
    ${CXX} -o ${TEMPDIR}/_ ./basics.cpp
    sutbin=${TEMPDIR}/_
}

runLLDB() {
    cat >${TEMPDIR}/script.py <<"EOF"
# import python standard lib
import os
import sys

# import lldb
import lldb

# create class
class Doer(object):
    def do_things(self):
        print(str(lldb))
        print("Doer does things")

# create exported function
# this function is available in lldb
def script_main(arg=None):
    doer = Doer()
    doer.do_things()
EOF

    # note the script module is available after importing
    # just like other normal Python modules
    ${DBG} --batch \
-o "command script import ${TEMPDIR}/script.py" \
-o "script print(script)" \
-o "script script.script_main()"
}

setUp
buildSUT
runLLDB
tearDown
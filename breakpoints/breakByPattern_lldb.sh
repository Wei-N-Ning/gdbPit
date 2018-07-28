#!/usr/bin/env bash

# source
# https://lldb.llvm.org/lldb-gdb.html

set -e

TEMPDIR=/tmp/sut

tearDown() {
    rm -rf ${TEMPDIR} /tmp/_ /tmp/_.* /tmp/__*
}

setUp() {
    tearDown
    mkdir -p ${TEMPDIR}
}

CC=${CC-clang}
CXX=${CXX-clang++}
DBG=${DBG-lldb}

sutbin=
buildSUT() {
    cat >${TEMPDIR}/_.c << "EOF"
void there() {
}
void thereis() {
}
void thereisa() {
}
void thereisacow() {
}
int main() {
    there();
    thereis();
    thereisa();
    thereisacow();
    return 0;
}
EOF
    ${CC} -g -o ${TEMPDIR}/_ ${TEMPDIR}/_.c
    sutbin=${TEMPDIR}/_
}

# NOTE

# (lldb) breakpoint set --func-regex regular-expression
# (lldb) br s -r regular-expression

# (lldb) breakpoint list
# (lldb) br l
debugSUT() {
    cat >${TEMPDIR}/commands.lldb << "EOF"
br s -r there*
br l
EOF
    ${DBG} --batch -s ${TEMPDIR}/commands.lldb ${sutbin}
}

setUp
buildSUT
debugSUT
tearDown

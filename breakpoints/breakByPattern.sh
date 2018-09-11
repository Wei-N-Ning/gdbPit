#!/usr/bin/env bash

# note:
# a more common form looks like:
# rb some::dude::Param::method(some::man::Arg&) const$
# this excludes the trampling entry in the procedure link table (plt)

set -e

TEMPDIR=/tmp/sut

tearDown() {
    rm -rf ${TEMPDIR} /tmp/_ /tmp/_.* /tmp/__*
}

setUp() {
    tearDown
    mkdir -p ${TEMPDIR}
}

CC=${CC-gcc}
CXX=${CXX-g++}
DBG=${DBG-gdb}

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

debugSUT() {
    cat >${TEMPDIR}/commands.lldb << "EOF"
rbreak there*
i break
EOF
    ${DBG} --batch -command=${TEMPDIR}/commands.lldb ${sutbin}
}

setUp
buildSUT
debugSUT
tearDown

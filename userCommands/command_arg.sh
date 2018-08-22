#!/usr/bin/env bash

# source
# http://www.it.uom.gr/teaching/gcc_manuals/onlinedocs/gdb_21.html

# A user-defined command is a sequence of GDB commands to which you
# assign a new name as a command.

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

sutbin=
buildSUT() {
    cat > ${TEMPDIR}/_.c << "EOF"
int main() {
    int a = 99;
    int b = 9900;
    breakhere:
    return 0;
}
EOF
    ${CC} -g -o ${TEMPDIR}/_ ${TEMPDIR}/_.c
    sutbin=${TEMPDIR}/_
}

debugSUT() {
    cat >${TEMPDIR}/commands.gdb <<"EOF"
define addthese
    print $arg0 + $arg1
end

b main:breakhere
r
addthese a b
c
EOF
    ${DBG} -batch -command=${TEMPDIR}/commands.gdb ${sutbin}
}

setUp
buildSUT
debugSUT
tearDown

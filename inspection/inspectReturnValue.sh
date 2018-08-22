#!/usr/bin/env bash

# source
# https://stackoverflow.com/questions/267674/how-to-inspect-the-return-value-of-a-function-in-gdb
# print $eax or rax
# https://stackoverflow.com/questions/992406/examining-function-return-value-in-gdb?lq=1

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
int foo() {
    breakhere:
    return 1001;
}
int main() {
    foo();
    return 0;
}
EOF
    ${CC} -g -o ${TEMPDIR}/_ ${TEMPDIR}/_.c
    sutbin=${TEMPDIR}/_
}

debugSUT() {
    cat >${TEMPDIR}/commands.gdb <<"EOF"
b foo:breakhere
r
fin
c
EOF
    ${DBG} -batch -command=${TEMPDIR}/commands.gdb ${sutbin}
}

setUp
buildSUT
debugSUT
tearDown

#!/usr/bin/env bash

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

buildSUT() {
    cat > ${TEMPDIR}/sut.c << "EOF"
#include <stdlib.h>
void to_stop(int count) {
    int sum = 0;
    for (int i = 0; i <= count; ++i) {
        sum += i;
    }
}
int main() {
    int count = 13;
    to_stop(count);
    return 0;
}
EOF
    ${CC} ${TEMPDIR}/sut.c -o ${TEMPDIR}/_
}

disassembleFunctionOffline() {
    ${DBG} --batch \
-o "disassemble -F intel -n main" \
${TEMPDIR}/_
}

disassembleFunctionRuntime() {
    cat >${TEMPDIR}/commands.lldb <<"EOF"
br s -n main
r
disassemble -F intel --pc
EOF
    ${DBG} --batch -s ${TEMPDIR}/commands.lldb ${TEMPDIR}/_
}

setUp
buildSUT
disassembleFunctionOffline
disassembleFunctionRuntime
tearDown

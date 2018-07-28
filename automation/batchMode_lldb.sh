#!/usr/bin/env bash

# source:
# https://lldb.llvm.org/lldb-gdb.html
# transit from GDB to LLDB

CC=${CC-cc}
CXX=${CXX-c++}
DBG=${DBG-lldb}

set -e

TEMPDIR=/tmp/sut

tearDown() {
    rm -rf ${TEMPDIR} /tmp/_ /tmp/_.* /tmp/__*
}

sutbin=
setUp() {
    tearDown
    mkdir -p ${TEMPDIR}
}

compile() {
    echo "
void ido() {
    ;
}

int main() {
    ido();
    return 0;
}
" >${TEMPDIR}/ido.c
    ${CC} -g -o ${TEMPDIR}/ido ${TEMPDIR}/ido.c
    sutbin=${TEMPDIR}/ido
}

# load binary
# set a breakpoint at subroutine named ido()
# run the binary
# (once stopped) inspect registers
runSutThenDumpRegisters() {
    ${DBG} --batch \
-o "breakpoint set --name ido" \
-o "run" \
-o "register read" ${sutbin}
}

# load binary
# inspect all the subroutine symbols

# NOTE:
# This one finds debug symbols:
# (lldb) image lookup -r -n <FUNC_REGEX>
#
# This one finds non-debug symbols:
# (lldb) image lookup -r -s <FUNC_REGEX>
listSutDebugSymbols() {
    ${DBG} -batch \
-o "image lookup -r -n .*" ${sutbin}
}

setUp
compile
runSutThenDumpRegisters
listSutDebugSymbols
tearDown

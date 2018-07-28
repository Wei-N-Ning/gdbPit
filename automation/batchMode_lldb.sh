#!/usr/bin/env bash

# source:
# https://lldb.llvm.org/lldb-gdb.html
# transit from GDB to LLDB

# this is also helpful:
# https://stackoverflow.com/questions/26812047/scripting-lldb-to-obtain-a-stack-trace-after-a-crash

# also read:
# https://gist.github.com/rongierlach/97362cfc7ebe2194fb7315d0375c5b5a


CC=${CC-clang}
CXX=${CXX-clang++}
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

    # same commands but using a command file
    # this is equivalent to gdb -batch -command=/some/file
    echo "
breakpoint set --name ido
run
register read
" >${TEMPDIR}/commands.lldb
    ${DBG} --batch -s ${TEMPDIR}/commands.lldb ${sutbin}
}

# load binary
# inspect all the subroutine symbols

# NOTE:
# This one finds debug symbols:
# (lldb) image lookup -r -n <FUNC_REGEX>
#
# This one finds non-debug symbols:
# (lldb) image lookup -r -s <FUNC_REGEX>

# UPDATE:
# image lookup -r -n on mac os shows too much information
# I have to use a stricter regex to filter the unwanted lines
listSutDebugSymbols() {
    ${DBG} --batch \
-o "image lookup -r -n ^ido$" ${sutbin}
}

setUp
compile
runSutThenDumpRegisters
listSutDebugSymbols
tearDown

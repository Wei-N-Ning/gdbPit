#!/usr/bin/env bash

CC=${CC-gcc}
CXX=${CXX-g++}
DBG=${DBG-gdb}

compile() {
    echo "
void ido() {
    ;
}

int main() {
    ido();
    return 0;
}
" > /tmp/ido.c
    ${CC} -g -o /tmp/ido /tmp/ido.c
}

# load binary
# set a breakpoint at subroutine named ido()
# run the binary
# (once stopped) inspect registers
runSutThenDumpRegisters() {
    ${DBG} -batch \
-ex "file /tmp/ido" \
-ex "break ido" \
-ex "run" \
-ex "i r"
}

# load binary
# inspect all the subroutine symbols
listSutDebugSymbols() {
    ${DBG} -batch \
-ex "file /tmp/ido" \
-ex "i func"
}

compile
runSutThenDumpRegisters
listSutDebugSymbols


#!/usr/bin/env bash

# source:

# ////// BEWARE OF OPTIMIZED C++ CODE //////
# https://gcc.gnu.org/onlinedocs/gcc/Local-Labels.html#Local-Labels

# ///////////////////
# NOTE: this require the target to carry debug symbols (-g)
# ///////////////////

# how to use label statements in C/C++ source code
# https://msdn.microsoft.com/en-us/library/wd6c3we5.aspx

# how to "retrieve" the breakpoint I just set
# https://stackoverflow.com/questions/11015371/getting-the-breakpoint-number-from-gdb

# how to set breakpoint at source label:
# https://sourceware.org/gdb/onlinedocs/gdb/Linespec-Locations.html#Linespec-Locations
# function:label
# Specifies the line where label appears in function.

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
    breakhere:
    return 0;
}
EOF
    ${CC} -g -o ${TEMPDIR}/_ ${TEMPDIR}/_.c
    sutbin=${TEMPDIR}/_
}

debugSUT() {
    cat >${TEMPDIR}/commands.gdb <<"EOF"
b main:breakhere
set $breakhere_id = $bpnum
command $breakhere_id
echo breakhere-breakhere-breakhere\n
continue
end
r
EOF
    ${DBG} -batch -command=${TEMPDIR}/commands.gdb ${sutbin}
}

setUp
buildSUT
debugSUT
tearDown

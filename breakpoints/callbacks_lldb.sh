#!/usr/bin/env bash

# source:
# https://lldb.llvm.org/lldb-gdb.html
# https://lldb.llvm.org/tutorial.html

# note how to set breakpoint on C++ method

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
    cat > ${TEMPDIR}/conditional.cc << "EOF"
#include <memory>
#include <vector>

using Vec = std::vector<int>;
using SPVec = std::shared_ptr<Vec>;

SPVec create(int size) {
    return SPVec(new Vec(size, 2));
}

void repopulate(SPVec &spVec, int num, int value) {
    for (int i=num; i--; ) {
        spVec->emplace_back(value);
    }
}

void reset(SPVec &spVec) {
    while (! spVec->empty()) {
        spVec->pop_back();
    }
}

int main(int argc, char **argv) {
    auto spVec = create(1);
    repopulate(spVec, 10, 23);
    reset(spVec);
    return 0;
}
EOF
    ${CXX} -g -std=c++14 -o ${TEMPDIR}/_ ${TEMPDIR}/conditional.cc
    sutbin=${TEMPDIR}/_
}

# > Setting Breakpoints
# (lldb) breakpoint set --file test.c --line 12
# (lldb) br s -f test.c -l 12
# (lldb) b test.c:12
# command 1

# > Setting Breakpoint with Condition
# experiment:
# sut program won't be stopped if the condition is set to (impossible
# to meet)
# --condition 'spVec->size() > 3999'

# > Inspect frame variables
# gdb's info args/ info locals is implemented as:
# (lldb) frame variable
# (lldb) fr v
debugSUT() {
    cat > ${TEMPDIR}/commands.txt << "EOF"
br s -f conditional.cc -l 26 --condition 'spVec->size() > 3'
br command add 1.1
frame variable
DONE
r
c
EOF
    ${DBG} --batch -s ${TEMPDIR}/commands.txt ${sutbin}
}

setUp
buildSUT
debugSUT
tearDown

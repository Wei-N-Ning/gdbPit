#!/usr/bin/env bash

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

debugSUT() {
    cat > ${TEMPDIR}/commands.txt << "EOF"
break conditional.cc:26 if spVec->size() > 3
command 1
echo thereisacow\n
i frame
end
r
cont
EOF
    ${DBG} -batch -command=${TEMPDIR}/commands.txt ${sutbin}
}

setUp
buildSUT
debugSUT
tearDown

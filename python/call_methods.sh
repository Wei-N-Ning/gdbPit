#!/usr/bin/env bash

# source
# https://stackoverflow.com/questions/22774067/gdb-python-api-is-it-possible-to-make-a-call-to-a-class-struct-method
# use gdb.parse_and_eval()

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
    cat > ${TEMPDIR}/_.cc << "EOF"
#include <iostream>

struct SUT {
    void shoot();
};

void SUT::shoot() {
    std::cout << "////bang////" << std::endl;
}

void bar() {
}

void foo() {
    SUT sut;
    bar();
    bar();
    return;
}

int main() {
    foo();
    return 0;
}
EOF
    ${CXX} -O0 -std=c++14 -g -o ${TEMPDIR}/_ ${TEMPDIR}/_.cc
    sutbin=${TEMPDIR}/_
}

debugSUT() {
    ${DBG} -batch \
-ex "b foo" \
-ex 'r' \
-ex 'python gdb.parse_and_eval("(&sut)->shoot()")' \
-ex 'c' \
${sutbin}
}

setUp
buildSUT
debugSUT
tearDown
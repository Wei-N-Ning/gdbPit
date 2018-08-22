#!/usr/bin/env bash

# inspired by experience at work (wt)

# also inspired by this post:
# https://stackoverflow.com/questions/8941711/is-is-possible-to-set-a-gdb-watchpoint-programatically
# but instead of using a child process and ptrace I much prefer I light
# weight, non-intrusive method
#
# break immediately after the call to ctor seems reasonable
#
# NOTE:
# watching the address of the object is less useful
# unless the object is used as primitives (or value-semantics)
# watching the address of its field(s) can be useful

# the default watch point only monitors write accessing

# watch read-only accessing
# watch read-and-write accessing
# https://sourceware.org/gdb/onlinedocs/gdb/Set-Watchpoints.html


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
    cat > ${TEMPDIR}/_.cpp << "EOF"
#include <memory>

struct Data {
    char __padding[13];

    int m_value = 0;
    int m_id = 11;
};

using PData = std::shared_ptr<Data>;

PData factory(int v) {
    PData pData(new Data);
    breakhere:
    pData->m_value = v;
    return pData;
}

void process(PData pData) {
    pData->m_value += 101;
}

int main() {
    PData pData = factory(340);
    process(pData);
    return 0;
}
EOF
    ${CXX} -std=c++14 -g -o ${TEMPDIR}/_ ${TEMPDIR}/_.cpp
    sutbin=${TEMPDIR}/_
}

debugSUT() {
    cat >${TEMPDIR}/commands.gdb <<"EOF"
b factory:breakhere
commands $bpnum
watch *(int *)(&(pData->m_value))
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

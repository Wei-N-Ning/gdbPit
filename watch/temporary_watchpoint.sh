#!/usr/bin/env bash

# NOTE
# inspired by:

# > source label
# > gdb bpnum convenient variable

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
    int a;
    breakhere:
    a++;
    a++;
    a++;
    a++;
    a++;
    a++;
    return 0;
}
EOF
    ${CC} -g -o ${TEMPDIR}/_ ${TEMPDIR}/_.c
    sutbin=${TEMPDIR}/_
}

debugSUT() {
    cat >${TEMPDIR}/commands.gdb <<"EOF"
tb main:breakhere
r
watch a
set $a_wp_id = $bpnum
command $a_wp_id
echo stop-only-once\n
d $a_wp_id
i br
continue
end
c
EOF
    ${DBG} -batch -command=${TEMPDIR}/commands.gdb ${sutbin}
}

setUp
buildSUT
debugSUT
tearDown

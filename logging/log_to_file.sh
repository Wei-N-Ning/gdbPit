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

setUp

gdb -batch \
-ex "set logging on ${TEMPDIR}/_.log" \
-ex "print 1" \
-ex "print 2" \
-ex "quit"

cat ${TEMPDIR}/_.log

tearDown

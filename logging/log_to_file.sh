#!/usr/bin/env bash

# source:
# how to disable continue prompt
# https://stackoverflow.com/questions/28815621/how-to-disable-type-return-to-continue-or-q-return-to-quit-in-gdb


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
-ex "set pagination off" \
-ex "print 1" \
-ex "print 2" \
-ex "quit"

cat ${TEMPDIR}/_.log

tearDown

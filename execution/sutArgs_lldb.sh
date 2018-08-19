#!/usr/bin/env bash

# note the execution order:
# 1) script print 1
# 2) process is launched
# 3) python executable is called with the passing arguments (an oneliner)

# note "-- prog args" should be the last one in the command line,
# following all -o arguments

CC=${CC-clang}
CXX=${CXX-clang++}
DBG=${DBG-lldb}
PYTHON=$( which python )
PYTHON=${PYTHON:?missing python}

runLLDB() {
    ${DBG} --batch \
-o 'script print 1' \
-o 'pr la' \
-- ${PYTHON} -c "import os;os.environ['USER'] = 'DooM';print(len(os.environ))"
}

runLLDB


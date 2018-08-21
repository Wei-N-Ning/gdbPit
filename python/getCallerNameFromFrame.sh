#!/usr/bin/env bash

# see:
# https://stackoverflow.com/questions/32383404/is-it-possible-to-capture-python-gdb-variables-into-the-value-history

# this is similar to "break-if-(nth)caller-is-X"


# there are times when I need to look at "who" is calling a function;
# a breakpoint has been set on the function and its callback will unwind in the caller frames, looking for candidates 
# in the simplest cases I only need to know the caller function's name (qualified with namespaces etc..)

# for example, I'm interested in the caller at frame 11:
# f 11
# python print(gdb.selected_frame().name())

# to send this name back to gdb, so that the callback can use it for if-condition test:

# python caller_name = gdb.selected_frame().name()
# python gdb.execute('set $caller_name = {}'.format(caller_name))

# see also:
# https://sourceware.org/gdb/onlinedocs/gdb/Frames-In-Python.html
# to programmatically look at f 11 in python:
# python f = gdb.selected_frame()
# python for i in range(11): f = f.older()
# python print(f.name())

# once I can do this, I can implement a robust variable look up:
# https://stackoverflow.com/questions/30013252/get-all-global-variables-local-variables-in-gdbs-python-interface/31231722#31231722
# python [f.name for _ in f.block()]


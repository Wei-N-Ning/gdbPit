#!/usr/bin/env bash

# there are times when I need to look at "who" is calling a function;
# a breakpoint has been set on the function and its callback will unwind in the caller frames, looking for candidates 
# in the simplest cases I only need to know the caller function's name (qualified with namespaces etc..)

# for example, I'm interested in the caller at frame 11:
# f 11
# python print(gdb.selected_frame().name())

# to send this name back to gdb, so that the callback can use it for if-condition test:

# python caller_name = gdb.selected_frame().name()
# python gdb.execute('set $caller_name = {}'.format(caller_name))


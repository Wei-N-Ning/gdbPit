#!/usr/bin/env bash

# watch point can be used in combination with break point,

# here is an example case:

# SUT is crash due to memory corruption

# I have found the crash site and set a breakpoint at it

# then I can watch the change to the memory that causes
# the crash and find the offending code:


# I'm using a counter to set off the watch point
# watch -l works when the object goes out of scope;
cat >/dev/null <<"EOF"
set confirm off
d br

set $counter = 0
break something.cc:62
  commands
    set $counter++
    f 11
    if $counter == 16
      watch -l i_block.m_blocks[1]
    else
      continue
    end
    p i_block
    f 0
  end
EOF

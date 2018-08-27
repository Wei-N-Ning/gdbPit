
# how replay at a specific event (by event number)

source:

https://github.com/mozilla/rr/wiki/Usage

If you want to restart replay at a different event, you can pass the event number as an argument to the gdb run command, like so

```
(gdb) run 159937
...
[rr 2734 159846]For application/x-test found plugin libnptest.so

--------------------------------------------------
 ---> Reached target process 0 at event 159937.
--------------------------------------------------
```

# Checkpointing

rr supports gdb's checkpoint, restart and delete checkpoint commands.

# The 'when' command

During replay, the when command returns rr's internal current event number. Event numbers can be used as a parameter to the run command. E.g.

```
(gdb) when
$12 = 33818
(gdb) run 32818
... restarts 1000 events earlier ...
```



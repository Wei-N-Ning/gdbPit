
# build GDB

I found out how to build gdb in debug mode (O0, -ggdb3) so that I can 
debug itself:

```
cd binutils-gdb
make distclean
mkdir -p build/dbg
cd build/dbg
../../configure --prefix=/work/dev/c/github.com/powergun/binutils-gdb/build/dbg CPPFLAGS=-DDEBUG CXXFLAGS="-ggdb3 -O0 -frecord-gcc-switches"
make
```

Read:

https://stackoverflow.com/questions/4553735/gnu-autotools-debug-release-targets

Important:
```
Building with debug symbols or not is NOT something the project maintainer should worry about at all. This is an issue for the user. If you have a project and you want to make a debug build or a release build, you should use different options at configure time.
```

I needed to analyse GDB's backtrace functionality:

at this moment, I'm observing the behavior of gdb's backtrace_command() and trying to find out how it translates the address to line number

But eventually I decided to borrow libbacktrace - it is part of GCC



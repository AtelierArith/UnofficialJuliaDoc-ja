```
GC.safepoint()
```

Inserts a point in the program where garbage collection may run. This can be useful in rare cases in multi-threaded programs where some threads are allocating memory (and hence may need to run GC) but other threads are doing only simple operations (no allocation, task switches, or I/O). Calling this function periodically in non-allocating threads allows garbage collection to run.

!!! compat "Julia 1.4"
    This function is available as of Julia 1.4.


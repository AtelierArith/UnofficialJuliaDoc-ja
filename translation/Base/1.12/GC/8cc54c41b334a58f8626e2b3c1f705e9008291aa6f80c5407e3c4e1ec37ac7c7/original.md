```julia
GC.safepoint()
```

Inserts a point in the program where garbage collection may run.

Safepoints are fast and do not themselves trigger garbage collection. However, if another thread has requested the GC to run, reaching a safepoint will cause the current thread to block and wait for the GC.

This can be useful in rare cases in multi-threaded programs where some tasks are allocating memory (and hence may need to run GC) but other tasks are doing only simple operations (no allocation, task switches, or I/O), which do not yield control to Julia's runtime, and therefore blocks the GC from running. Calling this function periodically in the non-allocating tasks allows garbage collection to run.

Note that even though safepoints are fast (typically around 2 clock cycles), they can still degrade performance if called in a tight loop.

!!! compat "Julia 1.4"
    This function is available as of Julia 1.4.


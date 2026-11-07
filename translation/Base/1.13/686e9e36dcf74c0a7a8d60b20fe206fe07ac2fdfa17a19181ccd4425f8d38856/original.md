```julia
Base.full_sweep_reasons()
```

Return a dictionary of the number of times each full sweep reason has occurred.

The reasons are:

  * `:FULL_SWEEP_REASON_SWEEP_ALWAYS_FULL`: Full sweep was caused due to `always_full` being set in the GC debug environment
  * `:FULL_SWEEP_REASON_FORCED_FULL_SWEEP`: Full sweep was forced by `GC.gc(true)`
  * `:FULL_SWEEP_REASON_USER_MAX_EXCEEDED`: Full sweep was forced due to the system reaching the heap soft size limit
  * `:FULL_SWEEP_REASON_LARGE_PROMOTION_RATE`: Full sweep was forced by a large promotion rate across GC generations

Note that the set of reasons is not guaranteed to be stable across minor versions of Julia.

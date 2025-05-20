```
Profile
```

Profiling support.

## CPU profiling

  * `@profile foo()` to profile a specific call.
  * `Profile.print()` to print the report.
  * `Profile.clear()` to clear the buffer.
  * Send a SIGUSR1 (on linux) or SIGINFO (on macOS/BSD) signal to the process to automatically trigger a profile and print. i.e. `kill -s SIGUSR1/SIGINFO 1234`, where 1234 is the pid of the julia process. On macOS & BSD platforms `ctrl-t` can be used directly.

## Memory profiling

  * `Profile.Allocs.@profile [sample_rate=0.1] foo()` to sample allocations within a specific call. A sample rate of 1.0 will record everything; 0.0 will record nothing.
  * `Profile.Allocs.print()` to print the report.
  * `Profile.Allocs.clear()` to clear the buffer.

## Heap profiling

  * `Profile.take_heap_snapshot()` to record a `.heapsnapshot` record of the heap.
  * Set `JULIA_PROFILE_PEEK_HEAP_SNAPSHOT=true` to capture a heap snapshot when signal SIGINFO (ctrl-t) is sent.

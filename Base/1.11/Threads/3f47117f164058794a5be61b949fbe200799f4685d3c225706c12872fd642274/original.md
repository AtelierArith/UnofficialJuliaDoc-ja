```
Threads.maxthreadid() -> Int
```

Get a lower bound on the number of threads (across all thread pools) available to the Julia process, with atomic-acquire semantics. The result will always be greater than or equal to [`threadid()`](@ref) as well as `threadid(task)` for any task you were able to observe before calling `maxthreadid`.

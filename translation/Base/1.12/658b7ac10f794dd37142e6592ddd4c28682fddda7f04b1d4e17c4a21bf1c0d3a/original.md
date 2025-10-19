```julia
AsyncCondition()
```

Create a async condition that wakes up tasks waiting for it (by calling [`wait`](@ref) on the object) when notified from C by a call to `uv_async_send`. Waiting tasks are woken with an error when the object is closed (by [`close`](@ref)). Use [`isopen`](@ref) to check whether it is still active.

This provides an implicit acquire & release memory ordering between the sending and waiting threads.

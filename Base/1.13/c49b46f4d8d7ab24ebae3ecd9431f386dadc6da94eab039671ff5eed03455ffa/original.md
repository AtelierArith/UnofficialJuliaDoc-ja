```julia
yield(t::Task, arg = nothing)
```

A fast, unfair-scheduling version of `schedule(t, arg); yield()` which immediately yields to `t` before calling the scheduler.

Throws a `ConcurrencyViolationError` if `t` is the currently running task.

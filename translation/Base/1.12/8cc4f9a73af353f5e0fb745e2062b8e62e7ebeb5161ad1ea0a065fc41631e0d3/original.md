```julia
wait(t::Task; throw=true)
```

Wait for a `Task` to finish.

The keyword `throw` (defaults to `true`) controls whether a failed task results in an error, thrown as a [`TaskFailedException`](@ref) which wraps the failed task.

Throws a `ConcurrencyViolationError` if `t` is the currently running task, to prevent deadlocks.

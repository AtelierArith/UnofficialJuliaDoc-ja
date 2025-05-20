```
wait([x])
```

Block the current task until some event occurs, depending on the type of the argument:

  * [`Channel`](@ref): Wait for a value to be appended to the channel.
  * [`Condition`](@ref): Wait for [`notify`](@ref) on a condition and return the `val` parameter passed to `notify`. Waiting on a condition additionally allows passing `first=true` which results in the waiter being put *first* in line to wake up on `notify` instead of the usual first-in-first-out behavior.
  * `Process`: Wait for a process or process chain to exit. The `exitcode` field of a process can be used to determine success or failure.
  * [`Task`](@ref): Wait for a `Task` to finish. If the task fails with an exception, a `TaskFailedException` (which wraps the failed task) is thrown.
  * [`RawFD`](@ref): Wait for changes on a file descriptor (see the `FileWatching` package).

If no argument is passed, the task blocks for an undefined period. A task can only be restarted by an explicit call to [`schedule`](@ref) or [`yieldto`](@ref).

Often `wait` is called within a `while` loop to ensure a waited-for condition is met before proceeding.

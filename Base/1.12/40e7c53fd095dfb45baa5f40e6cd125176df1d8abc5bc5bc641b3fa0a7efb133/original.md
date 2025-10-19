```julia
waitany(tasks; throw=true) -> (done_tasks, remaining_tasks)
```

Wait until at least one of the given tasks have been completed.

If `throw` is `true`, throw `CompositeException` when one of the completed tasks completes with an exception.

The return value consists of two task vectors. The first one consists of completed tasks, and the other consists of uncompleted tasks.

!!! warning
    This may scale poorly compared to writing code that uses multiple individual tasks that each runs serially, since this needs to scan the list of `tasks` each time and synchronize with each one every time this is called. Or consider using [`waitall(tasks; failfast=true)`](@ref waitall) instead.


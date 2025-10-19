```julia
waitall(tasks; failfast=true, throw=true) -> (done_tasks, remaining_tasks)
```

Wait until all the given tasks have been completed.

If `failfast` is `true`, the function will return when at least one of the given tasks is finished by exception. If `throw` is `true`, throw `CompositeException` when one of the completed tasks has failed.

`failfast` and `throw` keyword arguments work independently; when only `throw=true` is specified, this function waits for all the tasks to complete.

The return value consists of two task vectors. The first one consists of completed tasks, and the other consists of uncompleted tasks.

```
schedule(t::Task, [val]; error=false)
```

Add a [`Task`](@ref) to the scheduler's queue. This causes the task to run constantly when the system is otherwise idle, unless the task performs a blocking operation such as [`wait`](@ref).

If a second argument `val` is provided, it will be passed to the task (via the return value of [`yieldto`](@ref)) when it runs again. If `error` is `true`, the value is raised as an exception in the woken task.

!!! warning
    It is incorrect to use `schedule` on an arbitrary `Task` that has already been started. See [the API reference](@ref low-level-schedule-wait) for more information.


!!! warning
    By default tasks will have the sticky bit set to true `t.sticky`. This models the historic default for [`@async`](@ref). Sticky tasks can only be run on the worker thread they are first scheduled on, and when scheduled will make the task that they were scheduled from sticky. To obtain the behavior of [`Threads.@spawn`](@ref) set the sticky bit manually to `false`.


# Examples

```jldoctest
julia> a5() = sum(i for i in 1:1000);

julia> b = Task(a5);

julia> istaskstarted(b)
false

julia> schedule(b);

julia> yield();

julia> istaskstarted(b)
true

julia> istaskdone(b)
true
```

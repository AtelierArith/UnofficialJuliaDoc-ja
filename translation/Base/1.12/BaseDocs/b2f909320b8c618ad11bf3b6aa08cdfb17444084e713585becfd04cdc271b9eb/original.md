```julia
Task(func[, reserved_stack::Int])
```

Create a `Task` (i.e. coroutine) to execute the given function `func` (which must be callable with no arguments). The task exits when this function returns. The task will run in the "world age" from the parent at construction when [`schedule`](@ref)d.

The optional `reserved_stack` argument specifies the size of the stack available for this task, in bytes. The default, `0`, uses the system-dependent stack size default.

!!! warning
    By default tasks will have the sticky bit set to true `t.sticky`. This models the historic default for [`@async`](@ref). Sticky tasks can only be run on the worker thread they are first scheduled on, and when scheduled will make the task that they were scheduled from sticky. To obtain the behavior of [`Threads.@spawn`](@ref) set the sticky bit manually to `false`.


# Examples

```jldoctest
julia> a() = sum(i for i in 1:1000);

julia> b = Task(a);
```

In this example, `b` is a runnable `Task` that hasn't started yet.

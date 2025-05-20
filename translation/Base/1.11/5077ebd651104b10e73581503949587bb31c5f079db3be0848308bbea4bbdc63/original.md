```
@task
```

Wrap an expression in a [`Task`](@ref) without executing it, and return the [`Task`](@ref). This only creates a task, and does not run it.

!!! warning
    By default tasks will have the sticky bit set to true `t.sticky`. This models the historic default for [`@async`](@ref). Sticky tasks can only be run on the worker thread they are first scheduled on, and when scheduled will make the task that they were scheduled from sticky. To obtain the behavior of [`Threads.@spawn`](@ref) set the sticky bit manually to `false`.


# Examples

```jldoctest
julia> a1() = sum(i for i in 1:1000);

julia> b = @task a1();

julia> istaskstarted(b)
false

julia> schedule(b);

julia> yield();

julia> istaskdone(b)
true
```

```julia
Threads.@spawn [:default|:interactive|:samepool] expr
```

Create a [`Task`](@ref) and [`schedule`](@ref) it to run on any available thread in the specified threadpool: `:default`, `:interactive`, or `:samepool` to use the same as the caller. `:default` is used if unspecified. The task is allocated to a thread once one becomes available. To wait for the task to finish, call [`wait`](@ref) on the result of this macro, or call [`fetch`](@ref) to wait and then obtain its return value.

Values can be interpolated into `@spawn` via `$`, which copies the value directly into the constructed underlying closure. This allows you to insert the *value* of a variable, isolating the asynchronous code from changes to the variable's value in the current task.

!!! note
    The thread that the task runs on may change if the task yields, therefore `threadid()` should not be treated as constant for a task. See [`Task Migration`](@ref man-task-migration), and the broader [multi-threading](@ref man-multithreading) manual for further important caveats. See also the chapter on [threadpools](@ref man-threadpools).


!!! compat "Julia 1.3"
    This macro is available as of Julia 1.3.


!!! compat "Julia 1.4"
    Interpolating values via `$` is available as of Julia 1.4.


!!! compat "Julia 1.9"
    A threadpool may be specified as of Julia 1.9.


!!! compat "Julia 1.12"
    The same threadpool may be specified as of Julia 1.12.


# Examples

```julia-repl
julia> t() = println("Hello from ", Threads.threadid());

julia> tasks = fetch.([Threads.@spawn t() for i in 1:4]);
Hello from 1
Hello from 1
Hello from 3
Hello from 4
```

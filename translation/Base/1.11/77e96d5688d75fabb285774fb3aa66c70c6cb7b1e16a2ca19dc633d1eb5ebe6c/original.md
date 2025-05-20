```
@async
```

Wrap an expression in a [`Task`](@ref) and add it to the local machine's scheduler queue.

Values can be interpolated into `@async` via `$`, which copies the value directly into the constructed underlying closure. This allows you to insert the *value* of a variable, isolating the asynchronous code from changes to the variable's value in the current task.

!!! warning
    It is strongly encouraged to favor `Threads.@spawn` over `@async` always **even when no parallelism is required** especially in publicly distributed libraries.  This is because a use of `@async` disables the migration of the *parent* task across worker threads in the current implementation of Julia.  Thus, seemingly innocent use of `@async` in a library function can have a large impact on the performance of very different parts of user applications.


!!! compat "Julia 1.4"
    Interpolating values via `$` is available as of Julia 1.4.


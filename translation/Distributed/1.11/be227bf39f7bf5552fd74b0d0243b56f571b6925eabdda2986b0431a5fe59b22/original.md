```julia
remote_do(f, pool::AbstractWorkerPool, args...; kwargs...) -> nothing
```

[`WorkerPool`](@ref) variant of `remote_do(f, pid, ....)`. Wait for and take a free worker from `pool` and perform a `remote_do` on it.

Note that it's not possible to wait for the result of a `remote_do()` to finish so the worker will immediately be put back in the pool (i.e. potentially causing oversubscription).

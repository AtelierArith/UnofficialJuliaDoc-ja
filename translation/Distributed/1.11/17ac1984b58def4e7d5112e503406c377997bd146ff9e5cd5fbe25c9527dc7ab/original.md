```
remote_do(f, pool::AbstractWorkerPool, args...; kwargs...) -> nothing
```

[`WorkerPool`](@ref) variant of `remote_do(f, pid, ....)`. Wait for and take a free worker from `pool` and perform a `remote_do` on it.

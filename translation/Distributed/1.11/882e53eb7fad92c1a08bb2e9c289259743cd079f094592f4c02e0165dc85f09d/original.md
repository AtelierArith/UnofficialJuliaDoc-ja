```julia
remote([p::AbstractWorkerPool], f) -> Function
```

Return an anonymous function that executes function `f` on an available worker (drawn from [`WorkerPool`](@ref) `p` if provided) using [`remotecall_fetch`](@ref).

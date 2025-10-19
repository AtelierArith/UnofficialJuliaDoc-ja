```julia
default_worker_pool()
```

[`AbstractWorkerPool`](@ref) containing idle [`workers`](@ref) - used by `remote(f)` and [`pmap`](@ref) (by default). Unless one is explicitly set via `default_worker_pool!(pool)`, the default worker pool is initialized to a [`WorkerPool`](@ref).

# Examples

```julia-repl
$ julia -p 3

julia> default_worker_pool()
WorkerPool(Channel{Int64}(sz_max:9223372036854775807,sz_curr:3), Set([4, 2, 3]), RemoteChannel{Channel{Any}}(1, 1, 4))
```

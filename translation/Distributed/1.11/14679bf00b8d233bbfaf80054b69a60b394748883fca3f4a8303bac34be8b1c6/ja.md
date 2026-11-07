```julia
default_worker_pool!(pool::AbstractWorkerPool)
```

`remote(f)`および[`pmap`](@ref)で（デフォルトで）使用する[`AbstractWorkerPool`](@ref)を設定します。

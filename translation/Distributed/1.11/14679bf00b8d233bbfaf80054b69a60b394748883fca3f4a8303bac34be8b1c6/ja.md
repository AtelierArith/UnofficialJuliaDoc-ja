```julia
default_worker_pool!(pool::AbstractWorkerPool)
```

[`AbstractWorkerPool`](@ref)を、`remote(f)`および[`pmap`](@ref)で使用するように設定します（デフォルト）。

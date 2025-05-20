```
default_worker_pool!(pool::AbstractWorkerPool)
```

[`AbstractWorkerPool`](@ref) を `remote(f)` と [`pmap`](@ref) で使用するように設定します（デフォルトで）。

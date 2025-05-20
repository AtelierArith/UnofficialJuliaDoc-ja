```
default_worker_pool!(pool::AbstractWorkerPool)
```

Set a [`AbstractWorkerPool`](@ref) to be used by `remote(f)` and [`pmap`](@ref) (by default).

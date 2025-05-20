```
remote_do(f, pool::AbstractWorkerPool, args...; kwargs...) -> nothing
```

[`WorkerPool`](@ref) のバリアントである `remote_do(f, pid, ....)`。`pool` から空いているワーカーを待って取得し、それに対して `remote_do` を実行します。

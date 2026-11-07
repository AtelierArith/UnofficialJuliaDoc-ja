```julia
remote_do(f, pool::AbstractWorkerPool, args...; kwargs...) -> nothing
```

[`WorkerPool`](@ref) は `remote_do(f, pid, ....)` のバリアントです。`pool` から空いているワーカーを待って取得し、そのワーカー上で `remote_do` を実行します。

`remote_do()` の完了を待つことはできないため、ワーカーは直ちにプールに戻されます（その結果、過剰な並列実行が発生する可能性があります）。

```julia
remote_do(f, pool::AbstractWorkerPool, args...; kwargs...) -> nothing
```

[`WorkerPool`](@ref) の `remote_do(f, pid, ....)` のバリアントです。`pool` から空いているワーカーを待って取得し、それに対して `remote_do` を実行します。

`remote_do()` の結果が完了するのを待つことはできないため、ワーカーはすぐにプールに戻されます（つまり、過剰なサブスクリプションを引き起こす可能性があります）。

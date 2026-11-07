```julia
remote([p::AbstractWorkerPool], f) -> Function
```

[`WorkerPool`](@ref) `p` が指定されている場合はそこから選んだ利用可能なワーカー上で、[`remotecall_fetch`](@ref) を使って関数 `f` を実行する無名関数を返します。

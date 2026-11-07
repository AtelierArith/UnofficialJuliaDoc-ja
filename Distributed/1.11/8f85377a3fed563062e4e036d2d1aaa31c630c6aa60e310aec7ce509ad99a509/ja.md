```julia
remote([p::AbstractWorkerPool], f) -> Function
```

[`WorkerPool`](@ref) `p` が指定されている場合はそこから、それ以外の場合は利用可能なワーカーから選んで、`f` 関数を実行する無名関数を、[`remotecall_fetch`](@ref) を使って返します。

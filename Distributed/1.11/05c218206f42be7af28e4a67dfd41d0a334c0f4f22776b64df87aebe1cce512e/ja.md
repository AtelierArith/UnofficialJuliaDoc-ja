```julia
remotecall_fetch(f, pool::AbstractWorkerPool, args...; kwargs...) -> result
```

[`WorkerPool`](@ref) は `remotecall_fetch(f, pid, ....)` のバリアントです。空いているワーカーが現れるまで待機し、`pool` からそのワーカーを取得して、`remotecall_fetch` を実行します。

# Examples

```julia-repl
$ julia -p 3

julia> wp = WorkerPool([2, 3]);

julia> A = rand(3000);

julia> remotecall_fetch(maximum, wp, A)
0.9995177101692958
```

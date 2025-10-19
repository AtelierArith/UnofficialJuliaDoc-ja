```julia
remotecall_fetch(f, pool::AbstractWorkerPool, args...; kwargs...) -> result
```

[`WorkerPool`](@ref) の `remotecall_fetch(f, pid, ....)` のバリアント。`pool` から空いているワーカーを待って取得し、それに対して `remotecall_fetch` を実行します。

# 例

```julia-repl
$ julia -p 3

julia> wp = WorkerPool([2, 3]);

julia> A = rand(3000);

julia> remotecall_fetch(maximum, wp, A)
0.9995177101692958
```

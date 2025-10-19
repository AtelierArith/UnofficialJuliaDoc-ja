```julia
remotecall(f, pool::AbstractWorkerPool, args...; kwargs...) -> Future
```

[`WorkerPool`](@ref) のバリアントである `remotecall(f, pid, ....)`。`pool` から空いているワーカーを待って取得し、それに対して `remotecall` を実行します。

# 例

```julia-repl
$ julia -p 3

julia> wp = WorkerPool([2, 3]);

julia> A = rand(3000);

julia> f = remotecall(maximum, wp, A)
Future(2, 1, 6, nothing)
```

この例では、タスクは pid 2 で実行され、pid 1 から呼び出されました。

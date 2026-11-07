```julia
remotecall(f, pool::AbstractWorkerPool, args...; kwargs...) -> Future
```

[`WorkerPool`](@ref) は `remotecall(f, pid, ....)` のバリアントです。`pool` から空いているワーカーを待って取得し、そのワーカーに対して `remotecall` を実行します。

# Examples

```julia-repl
$ julia -p 3

julia> wp = WorkerPool([2, 3]);

julia> A = rand(3000);

julia> f = remotecall(maximum, wp, A)
Future(2, 1, 6, nothing)
```

この例では、pid 1 から呼び出されたタスクが pid 2 で実行されました。

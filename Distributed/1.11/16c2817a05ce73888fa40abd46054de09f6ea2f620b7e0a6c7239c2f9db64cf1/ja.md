```julia
remotecall_wait(f, pool::AbstractWorkerPool, args...; kwargs...) -> Future
```

[`WorkerPool`](@ref) は `remotecall_wait(f, pid, ....)` のバリアントです。`pool` から空いているワーカーを待って取得し、そのワーカーに対して `remotecall_wait` を実行します。

# Examples

```julia-repl
$ julia -p 3

julia> wp = WorkerPool([2, 3]);

julia> A = rand(3000);

julia> f = remotecall_wait(maximum, wp, A)
Future(3, 1, 9, nothing)

julia> fetch(f)
0.9995177101692958
```

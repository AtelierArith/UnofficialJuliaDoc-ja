```
default_worker_pool()
```

[`AbstractWorkerPool`](@ref) にはアイドル状態の [`workers`](@ref) が含まれており、`remote(f)` および [`pmap`](@ref)（デフォルトで）によって使用されます。`default_worker_pool!(pool)` を介して明示的に設定されない限り、デフォルトのワーカープールは [`WorkerPool`](@ref) に初期化されます。

# 例

```julia-repl
$ julia -p 3

julia> default_worker_pool()
WorkerPool(Channel{Int64}(sz_max:9223372036854775807,sz_curr:3), Set([4, 2, 3]), RemoteChannel{Channel{Any}}(1, 1, 4))
```

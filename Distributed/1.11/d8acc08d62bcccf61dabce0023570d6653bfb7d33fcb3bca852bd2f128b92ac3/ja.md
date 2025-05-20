```
WorkerPool(workers::Union{Vector{Int},AbstractRange{Int}})
```

ベクターまたはワーカーIDの範囲から `WorkerPool` を作成します。

# 例

```julia-repl
$ julia -p 3

julia> WorkerPool([2, 3])
WorkerPool(Channel{Int64}(sz_max:9223372036854775807,sz_curr:2), Set([2, 3]), RemoteChannel{Channel{Any}}(1, 1, 6))

julia> WorkerPool(2:4)
WorkerPool(Channel{Int64}(sz_max:9223372036854775807,sz_curr:2), Set([4, 2, 3]), RemoteChannel{Channel{Any}}(1, 1, 7))
```

```julia
default_worker_pool()
```

[`AbstractWorkerPool`](@ref) containing idle [`workers`](@ref) - `remote(f)`および[`pmap`](@ref)で使用されます（デフォルト）。`default_worker_pool!(pool)`で明示的に設定しない限り、デフォルトのワーカープールは[`WorkerPool`](@ref)に初期化されます。

# Examples

```julia-repl
$ julia -p 3

julia> default_worker_pool()
WorkerPool(Channel{Int64}(sz_max:9223372036854775807,sz_curr:3), Set([4, 2, 3]), RemoteChannel{Channel{Any}}(1, 1, 4))
```

```julia
remotecall_wait(f, id::Integer, args...; kwargs...)
```

worker id `id`で指定した`Worker`に対して、1回のメッセージでより高速な`wait(remotecall(...))`を実行します。キーワード引数がある場合は、`f`に渡されます。

[`wait`](@ref)および[`remotecall`](@ref)も参照してください。

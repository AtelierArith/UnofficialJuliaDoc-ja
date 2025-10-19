```julia
remotecall_wait(f, id::Integer, args...; kwargs...)
```

指定されたワーカーID `id` の `Worker` に対して、1つのメッセージでより高速な `wait(remotecall(...))` を実行します。キーワード引数がある場合、それらは `f` に渡されます。

[`wait`](@ref) および [`remotecall`](@ref) も参照してください。

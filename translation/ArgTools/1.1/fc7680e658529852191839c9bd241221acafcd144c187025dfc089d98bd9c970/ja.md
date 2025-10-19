```julia
ArgRead = Union{AbstractString, AbstractCmd, IO}
```

`ArgRead` タイプは、`arg_read` 関数が読み取り可能な IO ハンドルに変換する方法を知っているタイプのユニオンです。詳細については [`arg_read`](@ref) を参照してください。

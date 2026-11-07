```julia
isfieldatomic(t::DataType, s::Union{Int,Symbol})::Bool
```

指定した型 `t` で、フィールド `s` が `@atomic` として宣言されているかどうかを判定します。

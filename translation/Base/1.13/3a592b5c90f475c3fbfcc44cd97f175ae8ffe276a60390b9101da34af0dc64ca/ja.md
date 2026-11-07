```julia
isfieldatomic(t::DataType, s::Union{Int,Symbol})::Bool
```

指定された型 `t` にフィールド `s` が `@atomic` として宣言されているかどうかを判定します。

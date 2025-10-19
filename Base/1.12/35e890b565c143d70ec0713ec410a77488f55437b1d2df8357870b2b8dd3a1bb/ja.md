```julia
isfieldatomic(t::DataType, s::Union{Int,Symbol}) -> Bool
```

指定された型 `t` において、フィールド `s` が `@atomic` として宣言されているかどうかを判断します。

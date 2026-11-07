```julia
isassigned(v::Tuple, i::Integer) -> Bool
```

`true` を返します。ただし、インデックス `i` がタプル `v` の範囲内にある場合、つまり `1 ≤ i ≤ length(v)` の場合です。

!!! compat "Julia 1.13"
    このメソッドを使用するには、Julia 1.13 以降が必要です。


```julia
isassigned(v::Tuple, i::Integer) -> Bool
```

`i` がタプル `v` の範囲内にある場合、`true` を返します。つまり、`1 ≤ i ≤ length(v)` です。

!!! compat "Julia 1.13"
    このメソッドを使用するには、Julia 1.13 以降が必要です。


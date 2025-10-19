```julia
count_ones(x::Integer) -> Integer
```

`x`の2進数表現における1の数。

# 例

```jldoctest
julia> count_ones(7)
3

julia> count_ones(Int32(-1))
32
```

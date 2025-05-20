```
count_zeros(x::Integer) -> Integer
```

`x`の2進数表現におけるゼロの数。

# 例

```jldoctest
julia> count_zeros(Int32(2 ^ 16 - 1))
16

julia> count_zeros(-1)
0
```

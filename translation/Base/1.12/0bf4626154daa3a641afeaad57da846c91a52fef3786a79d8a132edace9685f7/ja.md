```julia
leading_ones(x::Integer) -> Integer
```

`x`の2進数表現の先頭にある1の数。

# 例

```jldoctest
julia> leading_ones(UInt32(2 ^ 32 - 2))
31
```

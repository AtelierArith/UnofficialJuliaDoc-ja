```julia
leading_zeros(x::Integer) -> Integer
```

`x`の2進数表現の先頭にあるゼロの数。

# 例

```jldoctest
julia> leading_zeros(Int32(1))
31
```

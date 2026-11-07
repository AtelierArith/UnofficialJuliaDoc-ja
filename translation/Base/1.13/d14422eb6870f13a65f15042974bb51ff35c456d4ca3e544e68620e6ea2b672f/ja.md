```julia
leading_ones(x::Integer)::Integer
```

`x`の2進表現の先頭に連続する1の個数。

# Examples

```jldoctest
julia> leading_ones(UInt32(2 ^ 32 - 2))
31
```

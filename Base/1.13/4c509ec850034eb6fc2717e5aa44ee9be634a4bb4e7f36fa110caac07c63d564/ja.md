```julia
count_zeros(x::Integer)::Integer
```

`x`の2進表現に含まれる0の個数。

# Examples

```jldoctest
julia> count_zeros(Int32(2 ^ 16 - 1))
16

julia> count_zeros(-1)
0
```

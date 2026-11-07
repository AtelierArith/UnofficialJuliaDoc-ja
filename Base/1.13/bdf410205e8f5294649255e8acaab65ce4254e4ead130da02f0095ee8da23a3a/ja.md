```julia
count_ones(x::Integer)::Integer
```

`x`の2進表現に含まれる1の個数。

# Examples

```jldoctest
julia> count_ones(7)
3

julia> count_ones(Int32(-1))
32
```

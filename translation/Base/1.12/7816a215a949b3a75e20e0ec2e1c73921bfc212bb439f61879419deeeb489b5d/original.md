```julia
count_ones(x::Integer) -> Integer
```

Number of ones in the binary representation of `x`.

# Examples

```jldoctest
julia> count_ones(7)
3

julia> count_ones(Int32(-1))
32
```

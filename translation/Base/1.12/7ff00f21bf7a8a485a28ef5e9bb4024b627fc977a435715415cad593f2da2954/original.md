```julia
count_zeros(x::Integer) -> Integer
```

Number of zeros in the binary representation of `x`.

# Examples

```jldoctest
julia> count_zeros(Int32(2 ^ 16 - 1))
16

julia> count_zeros(-1)
0
```

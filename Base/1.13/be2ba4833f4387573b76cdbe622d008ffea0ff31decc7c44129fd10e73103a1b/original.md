```julia
top_set_bit(x::Integer)::Integer
```

The number of bits in `x`'s binary representation, excluding leading zeros.

Equivalently, the position of the most significant set bit in `x`'s binary representation, measured from the least significant side.

Negative `x` are only supported when `x::BitSigned`.

See also: [`ndigits0z`](@ref), [`ndigits`](@ref).

# Examples

```jldoctest
julia> Base.top_set_bit(4)
3

julia> Base.top_set_bit(0)
0

julia> Base.top_set_bit(-1)
64
```

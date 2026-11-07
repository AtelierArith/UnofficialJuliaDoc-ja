```julia
mul_hi(a::T, b::T) where {T<:Base.Integer}
```

Returns the higher half of the product of `a` and `b` where `T` is a fixed size integer.

# Examples

```jldoctest
julia> Base.mul_hi(12345678987654321, 123456789)
82624

julia> (widen(12345678987654321) * 123456789) >> 64
82624

julia> Base.mul_hi(0xff, 0xff)
0xfe
```

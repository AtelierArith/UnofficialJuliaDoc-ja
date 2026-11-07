```julia
mul_hi(a::T, b::T) where {T<:Base.Integer}
```

`a` と `b` の積の上位半分を返します。`T` は固定サイズ整数です。

# Examples

```jldoctest
julia> Base.mul_hi(12345678987654321, 123456789)
82624

julia> (widen(12345678987654321) * 123456789) >> 64
82624

julia> Base.mul_hi(0xff, 0xff)
0xfe
```

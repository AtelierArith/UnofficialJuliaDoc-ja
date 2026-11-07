```julia
top_set_bit(x::Integer)::Integer
```

先頭のゼロを除いた、`x`の2進表現のビット数。

言い換えると、`x`の2進表現で、最下位ビットから数えた最上位のセットビットの位置。

負の`x`は、`x::BitSigned`の場合にのみサポートされます。

関連項目: [`ndigits0z`](@ref)、[`ndigits`](@ref)。

# Examples

```jldoctest
julia> Base.top_set_bit(4)
3

julia> Base.top_set_bit(0)
0

julia> Base.top_set_bit(-1)
64
```

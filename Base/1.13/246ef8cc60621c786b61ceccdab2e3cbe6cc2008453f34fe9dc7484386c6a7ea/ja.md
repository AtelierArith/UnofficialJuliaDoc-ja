```julia
abs(x)
```

`x`の絶対値。

`abs`を符号付き整数に適用すると、オーバーフローが発生し、負の値が返されることがあります。このオーバーフローは、符号付き整数で表現可能な最小値に`abs`を適用した場合にのみ発生します。つまり、`x == typemin(typeof(x))`の場合は`abs(x) == x < 0`となり、予想される`-x`にはなりません。

関連項目：[`abs2`](@ref)、[`unsigned`](@ref)、[`sign`](@ref)。

# Examples

```jldoctest
julia> abs(-3)
3

julia> abs(1 + im)
1.4142135623730951

julia> abs.(Int8[-128 -127 -126 0 126 127])  # overflow at typemin(Int8)
1×6 Matrix{Int8}:
 -128  127  126  0  126  127

julia> maximum(abs, [1, -2, 3, -4])
4
```

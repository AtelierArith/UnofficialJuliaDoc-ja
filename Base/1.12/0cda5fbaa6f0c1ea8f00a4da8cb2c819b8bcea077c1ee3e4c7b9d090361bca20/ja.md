```julia
abs(x)
```

`x`の絶対値。

`abs`が符号付き整数に適用されると、オーバーフローが発生する可能性があり、その結果、負の値が返されることがあります。このオーバーフローは、`abs`が符号付き整数の最小表現可能値に適用されるときのみ発生します。つまり、`x == typemin(typeof(x))`のとき、`abs(x) == x < 0`となり、期待される`-x`ではありません。

参照: [`abs2`](@ref), [`unsigned`](@ref), [`sign`](@ref)。

# 例

```jldoctest
julia> abs(-3)
3

julia> abs(1 + im)
1.4142135623730951

julia> abs.(Int8[-128 -127 -126 0 126 127])  # typemin(Int8)でオーバーフロー
1×6 Matrix{Int8}:
 -128  127  126  0  126  127

julia> maximum(abs, [1, -2, 3, -4])
4
```

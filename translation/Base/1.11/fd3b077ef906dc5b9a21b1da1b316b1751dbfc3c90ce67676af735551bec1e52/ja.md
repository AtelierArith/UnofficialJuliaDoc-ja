```
zero(x)
zero(::Type)
```

`x`の型に対する加法単位元を取得します（`x`は型自体を指定することもできます）。

関連項目としては、[`iszero`](@ref)、[`one`](@ref)、[`oneunit`](@ref)、[`oftype`](@ref)があります。

# 例

```jldoctest
julia> zero(1)
0

julia> zero(big"2.0")
0.0

julia> zero(rand(2,2))
2×2 Matrix{Float64}:
 0.0  0.0
 0.0  0.0
```

```julia
abs2(x)
```

`x` の絶対値の二乗。

特に、`abs(x)` の計算に [`hypot`](@ref) による平方根が必要な複素数の場合、`abs(x)^2` より高速になることがあります。

[`abs`](@ref)、[`conj`](@ref)、[`real`](@ref) も参照してください。

# Examples

```jldoctest
julia> abs2(-3)
9

julia> abs2(3.0 + 4.0im)
25.0

julia> sum(abs2, [1+2im, 3+4im])  # LinearAlgebra.norm(x)^2
30
```

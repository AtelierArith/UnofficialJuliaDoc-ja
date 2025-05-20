```
abs2(x)
```

`x`の二乗絶対値。

これは、特に`abs(x)`が[`hypot`](@ref)を介して平方根を必要とする複素数の場合、`abs(x)^2`よりも速くなることがあります。

他に[`abs`](@ref)、[`conj`](@ref)、[`real`](@ref)も参照してください。

# 例

```jldoctest
julia> abs2(-3)
9

julia> abs2(3.0 + 4.0im)
25.0

julia> sum(abs2, [1+2im, 3+4im])  # LinearAlgebra.norm(x)^2
30
```

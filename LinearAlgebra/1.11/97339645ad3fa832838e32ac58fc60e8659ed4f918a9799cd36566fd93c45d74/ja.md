```
cis(A::AbstractMatrix)
```

平方行列 `A` の `exp(im*A)` のより効率的な方法（特に `A` が `Hermitian` または実対称行列の場合）。

[`cispi`](@ref)、[`sincos`](@ref)、[`exp`](@ref) も参照してください。

!!! compat "Julia 1.7"
    行列に対して `cis` を使用するサポートは Julia 1.7 で追加されました。


# 例

```jldoctest
julia> cis([π 0; 0 π]) ≈ -I
true
```

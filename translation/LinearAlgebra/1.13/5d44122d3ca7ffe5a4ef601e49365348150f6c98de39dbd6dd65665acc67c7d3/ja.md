```julia
cis(A::AbstractMatrix)
```

正方行列 `A` の `exp(im*A)` をより効率的に計算する方法です（特に、`A` が `Hermitian` または実数の `Symmetric` の場合）。

[`cispi`](@ref)、[`sincos`](@ref)、[`exp`](@ref) も参照してください。

!!! compat "Julia 1.7"
    行列に対する `cis` のサポートは Julia 1.7 で追加されました。


# Examples

```jldoctest
julia> cis([π 0; 0 π]) ≈ -I
true
```

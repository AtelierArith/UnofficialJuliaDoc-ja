```julia
tan(A::AbstractMatrix)
```

正方行列 `A` の行列正接を計算します。

`A` が実対称行列またはエルミート行列の場合は、その固有分解（[`eigen`](@ref)）を使って正接を計算します。それ以外の場合は、[`exp`](@ref) を呼び出して正接を求めます。

# Examples

```jldoctest
julia> tan(fill(1.0, (2,2)))
2×2 Matrix{Float64}:
 -1.09252  -1.09252
 -1.09252  -1.09252
```

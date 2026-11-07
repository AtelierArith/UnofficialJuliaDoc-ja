```julia
cos(A::AbstractMatrix)
```

正方行列 `A` の行列余弦を計算します。

`A` が実対称行列またはエルミート行列の場合は、その固有値分解（[`eigen`](@ref)）を使って余弦を計算します。それ以外の場合は、[`exp`](@ref) を呼び出して余弦を求めます。

# Examples

```jldoctest
julia> cos(fill(1.0, (2,2)))
2×2 Matrix{Float64}:
  0.291927  -0.708073
 -0.708073   0.291927
```

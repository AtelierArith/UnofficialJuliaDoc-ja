```julia
sincos(A::AbstractMatrix)
```

正方行列 `A` の行列正弦と行列余弦を計算します。

# Examples

```jldoctest
julia> S, C = sincos(fill(1.0, (2,2)));

julia> S
2×2 Matrix{Float64}:
 0.454649  0.454649
 0.454649  0.454649

julia> C
2×2 Matrix{Float64}:
  0.291927  -0.708073
 -0.708073   0.291927
```

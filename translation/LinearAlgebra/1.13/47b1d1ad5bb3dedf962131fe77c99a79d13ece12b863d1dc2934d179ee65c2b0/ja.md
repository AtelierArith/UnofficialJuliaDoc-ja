```julia
eigvecs(A; permute::Bool=true, scale::Bool=true, `sortby`) -> Matrix
```

列が`A`の固有ベクトルとなる行列`M`を返します。（`k`番目の固有ベクトルは、スライス`M[:, k]`から取得できます。）キーワード`permute`、`scale`、`sortby`は、[`eigen`](@ref)の場合と同じです。

# Examples

```jldoctest
julia> eigvecs([1.0 0.0 0.0; 0.0 3.0 0.0; 0.0 0.0 18.0])
3×3 Matrix{Float64}:
 1.0  0.0  0.0
 0.0  1.0  0.0
 0.0  0.0  1.0
```

```
eigvecs(A; permute::Bool=true, scale::Bool=true, `sortby`) -> Matrix
```

行列 `A` の固有ベクトルからなる行列 `M` を返します。(`k` 番目の固有ベクトルはスライス `M[:, k]` から取得できます。) `permute`、`scale`、および `sortby` キーワードは [`eigen`](@ref) と同じです。

# 例

```jldoctest
julia> eigvecs([1.0 0.0 0.0; 0.0 3.0 0.0; 0.0 0.0 18.0])
3×3 Matrix{Float64}:
 1.0  0.0  0.0
 0.0  1.0  0.0
 0.0  0.0  1.0
```

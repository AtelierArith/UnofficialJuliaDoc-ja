```julia
eigvecs(A::SymTridiagonal[, eigvals]) -> Matrix
```

行列 `M` を返し、その列は `A` の固有ベクトルです。(`k` 番目の固有ベクトルはスライス `M[:, k]` から取得できます。)

オプションの固有値ベクトル `eigvals` が指定されている場合、`eigvecs` は対応する特定の固有ベクトルを返します。

# 例

```jldoctest
julia> A = SymTridiagonal([1.; 2.; 1.], [2.; 3.])
3×3 SymTridiagonal{Float64, Vector{Float64}}:
 1.0  2.0   ⋅
 2.0  2.0  3.0
  ⋅   3.0  1.0

julia> eigvals(A)
3-element Vector{Float64}:
 -2.1400549446402604
  1.0000000000000002
  5.140054944640259

julia> eigvecs(A)
3×3 Matrix{Float64}:
  0.418304  -0.83205      0.364299
 -0.656749  -7.39009e-16  0.754109
  0.627457   0.5547       0.546448

julia> eigvecs(A, [1.])
3×1 Matrix{Float64}:
  0.8320502943378438
  4.263514128092366e-17
 -0.5547001962252291
```

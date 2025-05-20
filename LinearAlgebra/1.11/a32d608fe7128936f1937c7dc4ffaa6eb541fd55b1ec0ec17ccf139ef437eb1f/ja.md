```
Schur <: Factorization
```

行列 `A` のシュール分解の行列因子化タイプです。これは、対応する行列因子化関数 [`schur(_)`](@ref) の戻り値の型です。

`F::Schur` が因子化オブジェクトである場合、（準）三角シュール因子は `F.Schur` または `F.T` を介して取得でき、直交/ユニタリシュールベクトルは `F.vectors` または `F.Z` を介して取得できるため、`A = F.vectors * F.Schur * F.vectors'` となります。行列 `A` の固有値は `F.values` で取得できます。

分解を反復することで、成分 `F.T`、`F.Z`、および `F.values` が得られます。

# 例

```jldoctest
julia> A = [5. 7.; -2. -4.]
2×2 Matrix{Float64}:
  5.0   7.0
 -2.0  -4.0

julia> F = schur(A)
Schur{Float64, Matrix{Float64}, Vector{Float64}}
T因子:
2×2 Matrix{Float64}:
 3.0   9.0
 0.0  -2.0
Z因子:
2×2 Matrix{Float64}:
  0.961524  0.274721
 -0.274721  0.961524
固有値:
2要素 Vector{Float64}:
  3.0
 -2.0

julia> F.vectors * F.Schur * F.vectors'
2×2 Matrix{Float64}:
  5.0   7.0
 -2.0  -4.0

julia> t, z, vals = F; # 反復による分解

julia> t == F.T && z == F.Z && vals == F.values
true
```

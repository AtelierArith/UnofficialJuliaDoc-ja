```julia
Schur <: Factorization
```

行列 `A` のシュール分解における行列因子分解の型です。対応する行列因子分解関数 [`schur(_)`](@ref) の戻り値の型です。

因子分解オブジェクトが `F::Schur` の場合、（準）三角シュール因子は `F.Schur` または `F.T` で取得でき、直交／ユニタリなシュールベクトルは `F.vectors` または `F.Z` で取得できます。このとき `A = F.vectors * F.Schur * F.vectors'` が成り立ちます。`A` の固有値は `F.values` で取得できます。

分解を反復処理すると、成分 `F.T`、`F.Z`、`F.values` が得られます。

# Examples

```jldoctest
julia> A = [5. 7.; -2. -4.]
2×2 Matrix{Float64}:
  5.0   7.0
 -2.0  -4.0

julia> F = schur(A)
Schur{Float64, Matrix{Float64}, Vector{Float64}}
T factor:
2×2 Matrix{Float64}:
 3.0   9.0
 0.0  -2.0
Z factor:
2×2 Matrix{Float64}:
  0.961524  0.274721
 -0.274721  0.961524
eigenvalues:
2-element Vector{Float64}:
  3.0
 -2.0

julia> F.vectors * F.Schur * F.vectors'
2×2 Matrix{Float64}:
  5.0   7.0
 -2.0  -4.0

julia> t, z, vals = F; # destructuring via iteration

julia> t == F.T && z == F.Z && vals == F.values
true
```

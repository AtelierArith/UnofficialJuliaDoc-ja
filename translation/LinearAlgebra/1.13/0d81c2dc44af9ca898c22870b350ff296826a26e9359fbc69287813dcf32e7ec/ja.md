```julia
schur(A) -> F::Schur
```

行列 `A` のシュール分解を計算します。（準）三角シュール因子は、`Schur` オブジェクト `F` から `F.Schur` または `F.T` を使って取得できます。また、直交／ユニタリなシュールベクトルは `F.vectors` または `F.Z` を使って取得でき、`A = F.vectors * F.Schur * F.vectors'` が成り立ちます。`A` の固有値は `F.values` で取得できます。

実数の `A` の場合、シュール因子は「準三角」です。これは、複素固有値の共役ペアごとに対角ブロックが 2×2 となる点を除き、上三角行列であることを意味します。このため、複素固有値があっても分解をすべて実数で表せます。実数の準三角分解から、複素数の純粋な上三角シュール分解を得るには、`Schur{Complex}(schur(A))` を使用します。

分解を反復すると、成分 `F.T`、`F.Z`、`F.values` が得られます。

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

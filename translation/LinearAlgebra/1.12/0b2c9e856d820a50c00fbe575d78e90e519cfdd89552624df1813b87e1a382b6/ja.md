```julia
schur(A) -> F::Schur
```

行列 `A` のシュール分解を計算します。 (準)三角シュール因子は、`Schur` オブジェクト `F` から `F.Schur` または `F.T` を使用して取得でき、直交/ユニタリシュールベクトルは `F.vectors` または `F.Z` を使用して取得できるため、`A = F.vectors * F.Schur * F.vectors'` となります。行列 `A` の固有値は `F.values` で取得できます。

実数の `A` に対して、シュール分解は「準三角形」であり、これは複素固有値の共役対に対して 2×2 の対角ブロックを持つ上三角行列であることを意味します。これにより、複素固有値が存在しても分解が純粋に実数であることが可能です。実数の準三角形因子から (複素) 純上三角シュール分解を取得するには、`Schur{Complex}(schur(A))` を使用できます。

分解を繰り返すことで、成分 `F.T`、`F.Z`、および `F.values` が得られます。

# 例

```jldoctest
julia> A = [5. 7.; -2. -4.]
2×2 Matrix{Float64}:
  5.0   7.0
 -2.0  -4.0

julia> F = schur(A)
Schur{Float64, Matrix{Float64}, Vector{Float64}}
T 因子:
2×2 Matrix{Float64}:
 3.0   9.0
 0.0  -2.0
Z 因子:
2×2 Matrix{Float64}:
  0.961524  0.274721
 -0.274721  0.961524
固有値:
2-element Vector{Float64}:
  3.0
 -2.0

julia> F.vectors * F.Schur * F.vectors'
2×2 Matrix{Float64}:
  5.0   7.0
 -2.0  -4.0

julia> t, z, vals = F; # 繰り返しによる分解

julia> t == F.T && z == F.Z && vals == F.values
true
```

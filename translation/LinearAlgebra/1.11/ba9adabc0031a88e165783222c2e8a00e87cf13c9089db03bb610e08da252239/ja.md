```
Eigen <: Factorization
```

行列 `A` の固有値/スペクトル分解の行列因子化タイプです。これは、対応する行列因子化関数 [`eigen`](@ref) の戻り値の型です。

`F::Eigen` が因子化オブジェクトである場合、固有値は `F.values` を介して取得でき、固有ベクトルは行列 `F.vectors` の列として取得できます。（`k` 番目の固有ベクトルはスライス `F.vectors[:, k]` から取得できます。）

分解を反復すると、コンポーネント `F.values` と `F.vectors` が得られます。

# 例

```jldoctest
julia> F = eigen([1.0 0.0 0.0; 0.0 3.0 0.0; 0.0 0.0 18.0])
Eigen{Float64, Float64, Matrix{Float64}, Vector{Float64}}
values:
3-element Vector{Float64}:
  1.0
  3.0
 18.0
vectors:
3×3 Matrix{Float64}:
 1.0  0.0  0.0
 0.0  1.0  0.0
 0.0  0.0  1.0

julia> F.values
3-element Vector{Float64}:
  1.0
  3.0
 18.0

julia> F.vectors
3×3 Matrix{Float64}:
 1.0  0.0  0.0
 0.0  1.0  0.0
 0.0  0.0  1.0

julia> vals, vecs = F; # 反復による分解

julia> vals == F.values && vecs == F.vectors
true
```

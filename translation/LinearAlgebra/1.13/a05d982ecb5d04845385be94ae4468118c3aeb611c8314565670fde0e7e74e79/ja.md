```julia
Eigen <: Factorization
```

正方行列 `A` の固有値分解／スペクトル分解を表す行列因子分解型です。対応する行列因子分解関数 [`eigen`](@ref) の戻り値の型です。

`F::Eigen` が因子分解オブジェクトの場合、固有値は `F.values` で取得でき、固有ベクトルは行列 `F.vectors` の列として得られます。（`k` 番目の固有ベクトルは、スライス `F.vectors[:, k]` から取得できます。）

この分解を反復すると、成分 `F.values` と `F.vectors` が得られます。

# Examples

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

julia> vals, vecs = F; # destructuring via iteration

julia> vals == F.values && vecs == F.vectors
true
```

```
GeneralizedEigen <: Factorization
```

行列 `A` と `B` の一般化固有値/スペクトル分解の行列因子化タイプです。これは、2つの行列引数で呼び出されたときの対応する行列因子化関数 [`eigen`](@ref) の戻り値の型です。

`F::GeneralizedEigen` が因子化オブジェクトである場合、固有値は `F.values` を介して取得でき、固有ベクトルは行列 `F.vectors` の列として取得できます。（`k` 番目の固有ベクトルはスライス `F.vectors[:, k]` から取得できます。）

分解を反復すると、コンポーネント `F.values` と `F.vectors` が生成されます。

# 例

```jldoctest
julia> A = [1 0; 0 -1]
2×2 Matrix{Int64}:
 1   0
 0  -1

julia> B = [0 1; 1 0]
2×2 Matrix{Int64}:
 0  1
 1  0

julia> F = eigen(A, B)
GeneralizedEigen{ComplexF64, ComplexF64, Matrix{ComplexF64}, Vector{ComplexF64}}
values:
2-element Vector{ComplexF64}:
 0.0 - 1.0im
 0.0 + 1.0im
vectors:
2×2 Matrix{ComplexF64}:
  0.0+1.0im   0.0-1.0im
 -1.0+0.0im  -1.0-0.0im

julia> F.values
2-element Vector{ComplexF64}:
 0.0 - 1.0im
 0.0 + 1.0im

julia> F.vectors
2×2 Matrix{ComplexF64}:
  0.0+1.0im   0.0-1.0im
 -1.0+0.0im  -1.0-0.0im

julia> vals, vecs = F; # destructuring via iteration

julia> vals == F.values && vecs == F.vectors
true
```

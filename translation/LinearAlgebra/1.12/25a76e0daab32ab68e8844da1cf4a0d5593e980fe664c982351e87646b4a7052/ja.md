```julia
BunchKaufman <: Factorization
```

対称行列またはエルミート行列 `A` のバンチ-カウフマン因子分解の行列因子化タイプで、`P'UDU'P` または `P'LDL'P` の形式を持ち、`A` に上三角（デフォルト）または下三角が格納されているかに応じて異なります。`A` が複素対称の場合、`U'` と `L'` は共役でない転置を示し、すなわちそれぞれ `transpose(U)` と `transpose(L)` です。これは [`bunchkaufman`](@ref) の戻り値の型であり、対応する行列因子化関数です。

`S::BunchKaufman` が因子分解オブジェクトである場合、コンポーネントは `S.uplo` と `S.p` に応じて適切に `S.D`、`S.U` または `S.L` を介して取得できます。

分解を反復することで、`S.uplo` と `S.p` に応じて適切に `S.D`、`S.U` または `S.L` のコンポーネントが得られます。

# 例

```jldoctest
julia> A = Float64.([1 2; 2 3])
2×2 Matrix{Float64}:
 1.0  2.0
 2.0  3.0

julia> S = bunchkaufman(A) # A gets wrapped internally by Symmetric(A)
BunchKaufman{Float64, Matrix{Float64}, Vector{Int64}}
D factor:
2×2 Tridiagonal{Float64, Vector{Float64}}:
 -0.333333  0.0
  0.0       3.0
U factor:
2×2 UnitUpperTriangular{Float64, Matrix{Float64}}:
 1.0  0.666667
  ⋅   1.0
permutation:
2-element Vector{Int64}:
 1
 2

julia> d, u, p = S; # destructuring via iteration

julia> d == S.D && u == S.U && p == S.p
true

julia> S = bunchkaufman(Symmetric(A, :L))
BunchKaufman{Float64, Matrix{Float64}, Vector{Int64}}
D factor:
2×2 Tridiagonal{Float64, Vector{Float64}}:
 3.0   0.0
 0.0  -0.333333
L factor:
2×2 UnitLowerTriangular{Float64, Matrix{Float64}}:
 1.0        ⋅
 0.666667  1.0
permutation:
2-element Vector{Int64}:
 2
 1
```

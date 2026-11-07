```julia
BunchKaufman <: Factorization
```

対称行列またはエルミート行列 `A` の Bunch-Kaufman 分解の行列分解型です。`A` に上三角部分（デフォルト）と下三角部分のどちらが格納されているかに応じて、`P'UDU'P` または `P'LDL'P` となります。ここで、`U` と `L` はそれぞれ上三角行列と下三角行列、`P` は置換行列、`D` は 1×1 および 2×2 ブロックからなるブロック対角行列です。`A` が複素対称行列の場合、`U'` と `L'` はそれぞれ共役を取らない転置、すなわち `transpose(U)` と `transpose(L)` を表します。これは、対応する行列分解関数 [`bunchkaufman`](@ref) の戻り値の型です。

`S::BunchKaufman` が分解オブジェクトの場合、`S.uplo` と `S.p` に応じて、適切な成分を `S.D`、`S.U`、または `S.L` で取得できます。

分解結果を反復処理すると、`S.uplo` と `S.p` に応じて、`S.D`、`S.U`、または `S.L` の成分が生成されます。

# Examples

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

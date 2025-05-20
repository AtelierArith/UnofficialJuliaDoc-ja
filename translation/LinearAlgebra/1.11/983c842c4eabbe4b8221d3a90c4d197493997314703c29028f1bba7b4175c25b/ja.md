```
BunchKaufman <: Factorization
```

対称行列またはエルミート行列 `A` のバンチ-カウフマン因子分解の行列因子化タイプを `P'UDU'P` または `P'LDL'P` として、`A` に上三角（デフォルト）または下三角が格納されているかに応じて決定します。`A` が複素対称である場合、`U'` と `L'` は共役でない転置を示し、すなわちそれぞれ `transpose(U)` と `transpose(L)` です。これは、対応する行列因子化関数 [`bunchkaufman`](@ref) の返り値の型です。

もし `S::BunchKaufman` が因子分解オブジェクトであれば、コンポーネントは `S.uplo` と `S.p` に応じて `S.D`、`S.U` または `S.L` を介して取得できます。

分解を反復することで、`S.uplo` と `S.p` に応じて適切なコンポーネント `S.D`、`S.U` または `S.L` を生成します。

# 例

```jldoctest
julia> A = Float64.([1 2; 2 3])
2×2 Matrix{Float64}:
 1.0  2.0
 2.0  3.0

julia> S = bunchkaufman(A) # A は内部的に Symmetric(A) でラップされます
BunchKaufman{Float64, Matrix{Float64}, Vector{Int64}}
D 因子:
2×2 Tridiagonal{Float64, Vector{Float64}}:
 -0.333333  0.0
  0.0       3.0
U 因子:
2×2 UnitUpperTriangular{Float64, Matrix{Float64}}:
 1.0  0.666667
  ⋅   1.0
置換:
2-element Vector{Int64}:
 1
 2

julia> d, u, p = S; # 反復による分解

julia> d == S.D && u == S.U && p == S.p
true

julia> S = bunchkaufman(Symmetric(A, :L))
BunchKaufman{Float64, Matrix{Float64}, Vector{Int64}}
D 因子:
2×2 Tridiagonal{Float64, Vector{Float64}}:
 3.0   0.0
 0.0  -0.333333
L 因子:
2×2 UnitLowerTriangular{Float64, Matrix{Float64}}:
 1.0        ⋅
 0.666667  1.0
置換:
2-element Vector{Int64}:
 2
 1
```

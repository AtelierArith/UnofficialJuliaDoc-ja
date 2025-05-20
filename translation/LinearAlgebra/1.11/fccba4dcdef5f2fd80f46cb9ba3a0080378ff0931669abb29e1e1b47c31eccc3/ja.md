```
CholeskyPivoted
```

密な対称/エルミート半正定値行列 `A` のピボット付きコレスキー分解の行列因子化タイプです。これは、対応する行列因子化関数 [`cholesky(_, ::RowMaximum)`](@ref) の返り値の型です。

三角形のコレスキー因子は、因子分解 `F::CholeskyPivoted` から `F.L` と `F.U` を介して取得でき、置換は `F.p` を介して取得できます。ここで、`A[F.p, F.p] ≈ Ur' * Ur ≈ Lr * Lr'` であり、`Ur = F.U[1:F.rank, :]` および `Lr = F.L[:, 1:F.rank]` です。または、`A ≈ Up' * Up ≈ Lp * Lp'` であり、`Up = F.U[1:F.rank, invperm(F.p)]` および `Lp = F.L[invperm(F.p), 1:F.rank]` です。

`CholeskyPivoted` オブジェクトに対して利用可能な関数は次のとおりです: [`size`](@ref), [`\`](@ref), [`inv`](@ref), [`det`](@ref), および [`rank`](@ref)。

分解を反復することで、成分 `L` と `U` が生成されます。

# 例

```jldoctest
julia> X = [1.0, 2.0, 3.0, 4.0];

julia> A = X * X';

julia> C = cholesky(A, RowMaximum(), check = false)
CholeskyPivoted{Float64, Matrix{Float64}, Vector{Int64}}
U因子のランクは1:
4×4 UpperTriangular{Float64, Matrix{Float64}}:
 4.0  2.0  3.0  1.0
  ⋅   0.0  6.0  2.0
  ⋅    ⋅   9.0  3.0
  ⋅    ⋅    ⋅   1.0
置換:
4要素のベクトル{Int64}:
 4
 2
 3
 1

julia> C.U[1:C.rank, :]' * C.U[1:C.rank, :] ≈ A[C.p, C.p]
true

julia> l, u = C; # 反復による分解

julia> l == C.L && u == C.U
true
```

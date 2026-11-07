```julia
CholeskyPivoted
```

密な対称／エルミート半正定値行列 `A` のピボット付きコレスキー分解を表す行列分解型です。対応する行列分解関数 [`cholesky(_, ::RowMaximum)`](@ref) の戻り値の型です。

三角コレスキー因子は、分解 `F::CholeskyPivoted` から `F.L` と `F.U` を使って取得できます。また、置換は `F.p` を使って取得できます。このとき、`A[F.p, F.p] ≈ Ur' * Ur ≈ Lr * Lr'` と `Ur = F.U[1:F.rank, :]` および `Lr = F.L[:, 1:F.rank]` を使う方法と、`A ≈ Up' * Up ≈ Lp * Lp'` と `Up = F.U[1:F.rank, invperm(F.p)]` および `Lp = F.L[invperm(F.p), 1:F.rank]` を使う方法があります。

`CholeskyPivoted` オブジェクトでは、次の関数を利用できます: [`size`](@ref)、[`\`](@ref)、[`inv`](@ref)、[`det`](@ref)、[`rank`](@ref)。

この分解を反復すると、成分 `L` と `U` が生成されます。

# Examples

```jldoctest
julia> X = [1.0, 2.0, 3.0, 4.0];

julia> A = X * X';

julia> C = cholesky(A, RowMaximum(), check = false)
CholeskyPivoted{Float64, Matrix{Float64}, Vector{Int64}}
U factor with rank 1:
4×4 UpperTriangular{Float64, Matrix{Float64}}:
 4.0  2.0  3.0  1.0
  ⋅   0.0  6.0  2.0
  ⋅    ⋅   9.0  3.0
  ⋅    ⋅    ⋅   1.0
permutation:
4-element Vector{Int64}:
 4
 2
 3
 1

julia> C.U[1:C.rank, :]' * C.U[1:C.rank, :] ≈ A[C.p, C.p]
true

julia> l, u = C; # destructuring via iteration

julia> l == C.L && u == C.U
true
```

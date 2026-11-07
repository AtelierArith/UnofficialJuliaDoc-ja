```julia
cholesky(A, RowMaximum(); tol = 0.0, check = true) -> CholeskyPivoted
```

密な対称半正定値行列 `A` のピボット付きコレスキー分解を計算し、[`CholeskyPivoted`](@ref) 分解を返します。行列 `A` は、[`Symmetric`](@ref)、[`Hermitian`](@ref) [`AbstractMatrix`](@ref)、または *完全に* 対称あるいはエルミートな `AbstractMatrix` のいずれかです。

三角コレスキー因子は、分解 `F` から `F.L` と `F.U` を使って取得できます。また、置換は `F.p` から取得できます。このとき、`A[F.p, F.p] ≈ Ur' * Ur ≈ Lr * Lr'` と `Ur = F.U[1:F.rank, :]` および `Lr = F.L[:, 1:F.rank]` を使う方法と、`A ≈ Up' * Up ≈ Lp * Lp'` と `Up = F.U[1:F.rank, invperm(F.p)]` および `Lp = F.L[invperm(F.p), 1:F.rank]` を使う方法があります。

`CholeskyPivoted` オブジェクトでは、次の関数を利用できます: [`size`](@ref)、[`\`](@ref)、[`inv`](@ref)、[`det`](@ref)、[`rank`](@ref)。

引数 `tol` は、ランク判定に用いる許容誤差を指定します。負の値の場合、許容誤差は `eps()*size(A,1)*maximum(diag(A))` と等しくなります。

構成時の丸め誤差によりわずかに非エルミートとなっている行列 `A` を、完全にエルミートな行列として扱うには、`cholesky` に渡す前に `Hermitian(A)` でラップしてください。

`check = true` の場合、分解に失敗するとエラーがスローされます。`check = false` の場合、分解が有効かどうか（[`issuccess`](@ref) を使って）確認する責任はユーザーにあります。

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

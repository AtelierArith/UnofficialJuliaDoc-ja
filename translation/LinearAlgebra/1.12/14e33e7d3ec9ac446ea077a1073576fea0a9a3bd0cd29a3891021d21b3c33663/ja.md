```julia
cholesky(A, RowMaximum(); tol = 0.0, check = true) -> CholeskyPivoted
```

密な対称半正定値行列 `A` のピボット付きコレスキー分解を計算し、[`CholeskyPivoted`](@ref) 分解を返します。行列 `A` は、[`Symmetric`](@ref) または [`Hermitian`](@ref) [`AbstractMatrix`](@ref) であるか、*完全に* 対称またはエルミートな `AbstractMatrix` である必要があります。

三角形のコレスキー因子は、分解 `F` から `F.L` と `F.U` を介して取得でき、置換は `F.p` を介して取得できます。ここで、`A[F.p, F.p] ≈ Ur' * Ur ≈ Lr * Lr'` であり、`Ur = F.U[1:F.rank, :]` および `Lr = F.L[:, 1:F.rank]` です。または、`A ≈ Up' * Up ≈ Lp * Lp'` であり、`Up = F.U[1:F.rank, invperm(F.p)]` および `Lp = F.L[invperm(F.p), 1:F.rank]` です。

`CholeskyPivoted` オブジェクトに対して利用可能な関数は次のとおりです: [`size`](@ref), [`\`](@ref), [`inv`](@ref), [`det`](@ref), および [`rank`](@ref)。

引数 `tol` は、ランクを決定するための許容誤差を決定します。負の値の場合、許容誤差は `eps()*size(A,1)*maximum(diag(A))` に等しくなります。

構築時の丸め誤差により、行列 `A` がわずかに非エルミートである場合は、`cholesky` に渡す前に `Hermitian(A)` でラップして、完全にエルミートとして扱います。

`check = true` の場合、分解が失敗した場合はエラーがスローされます。`check = false` の場合、分解の有効性を確認する責任はユーザーにあります（[`issuccess`](@ref) を介して）。

# 例

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

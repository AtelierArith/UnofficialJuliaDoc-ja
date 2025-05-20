```
cholesky(A, NoPivot(); check = true) -> Cholesky
```

密な対称正定値行列 `A` のコレスキー分解を計算し、[`Cholesky`](@ref) 分解を返します。行列 `A` は、[`Symmetric`](@ref) または [`Hermitian`](@ref) [`AbstractMatrix`](@ref) であるか、*完全に* 対称またはエルミートな `AbstractMatrix` である必要があります。

三角形のコレスキー因子は、分解 `F` から `F.L` および `F.U` を介して取得でき、`A ≈ F.U' * F.U ≈ F.L * F.L'` となります。

`Cholesky` オブジェクトに対して利用可能な関数は、[`size`](@ref)、[`\`](@ref)、[`inv`](@ref)、[`det`](@ref)、[`logdet`](@ref) および [`isposdef`](@ref) です。

構築時の丸め誤差により行列 `A` がわずかに非エルミートである場合は、`cholesky` に渡す前に `Hermitian(A)` でラップして、完全にエルミートとして扱います。

`check = true` の場合、分解が失敗した場合はエラーがスローされます。`check = false` の場合、分解の有効性を確認する責任（[`issuccess`](@ref) を介して）はユーザーにあります。

# 例

```jldoctest
julia> A = [4. 12. -16.; 12. 37. -43.; -16. -43. 98.]
3×3 Matrix{Float64}:
   4.0   12.0  -16.0
  12.0   37.0  -43.0
 -16.0  -43.0   98.0

julia> C = cholesky(A)
Cholesky{Float64, Matrix{Float64}}
U因子:
3×3 UpperTriangular{Float64, Matrix{Float64}}:
 2.0  6.0  -8.0
  ⋅   1.0   5.0
  ⋅    ⋅    3.0

julia> C.U
3×3 UpperTriangular{Float64, Matrix{Float64}}:
 2.0  6.0  -8.0
  ⋅   1.0   5.0
  ⋅    ⋅    3.0

julia> C.L
3×3 LowerTriangular{Float64, Matrix{Float64}}:
  2.0   ⋅    ⋅
  6.0  1.0   ⋅
 -8.0  5.0  3.0

julia> C.L * C.U == A
true
```

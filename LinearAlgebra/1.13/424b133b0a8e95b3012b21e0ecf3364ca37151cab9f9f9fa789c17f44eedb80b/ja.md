```julia
cholesky(A, NoPivot(); check = true) -> Cholesky
```

密な対称正定値行列 `A` のコレスキー分解を計算し、[`Cholesky`](@ref) 分解を返します。行列 `A` には、[`Symmetric`](@ref)、[`Hermitian`](@ref) [`AbstractMatrix`](@ref)、または *完全に* 対称な、あるいはエルミートな `AbstractMatrix` を指定できます。

三角コレスキー因子は、分解 `F` から `F.L` と `F.U` を使って取得できます。ここで、`A ≈ F.U' * F.U ≈ F.L * F.L'` です。

`Cholesky` オブジェクトでは、次の関数を使用できます。[`size`](@ref)、[`\`](@ref)、[`inv`](@ref)、[`det`](@ref)、[`logdet`](@ref)、[`isposdef`](@ref)。

行列 `A` の構築時に生じた丸め誤差により、行列がわずかに非エルミートになっている場合は、`cholesky` に渡す前に `Hermitian(A)` でラップすると、完全にエルミートな行列として扱えます。

`check = true` の場合、分解に失敗するとエラーがスローされます。`check = false` の場合、分解の妥当性を [`issuccess`](@ref) で確認する責任はユーザーにあります。

# Examples

```jldoctest
julia> A = [4. 12. -16.; 12. 37. -43.; -16. -43. 98.]
3×3 Matrix{Float64}:
   4.0   12.0  -16.0
  12.0   37.0  -43.0
 -16.0  -43.0   98.0

julia> C = cholesky(A)
Cholesky{Float64, Matrix{Float64}}
U factor:
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
3×3 LowerTriangular{Float64, Adjoint{Float64, Matrix{Float64}}}:
  2.0   ⋅    ⋅
  6.0  1.0   ⋅
 -8.0  5.0  3.0

julia> C.L * C.U == A
true
```

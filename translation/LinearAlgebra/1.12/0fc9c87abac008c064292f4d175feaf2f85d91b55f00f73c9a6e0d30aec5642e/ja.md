```julia
Cholesky <: Factorization
```

密な対称/エルミート正定値行列 `A` のコレスキー分解の行列因子化タイプです。これは、対応する行列因子化関数 [`cholesky`](@ref) の返り値の型です。

三角形のコレスキー因子は、因子化 `F::Cholesky` から `F.L` と `F.U` を介して取得でき、`A ≈ F.U' * F.U ≈ F.L * F.L'` となります。

`Cholesky` オブジェクトに対して利用可能な関数は、[`size`](@ref)、[`\`](@ref)、[`inv`](@ref)、[`det`](@ref)、[`logdet`](@ref)、および [`isposdef`](@ref) です。

分解を反復すると、成分 `L` と `U` が得られます。

# 例

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
3×3 LowerTriangular{Float64, Matrix{Float64}}:
  2.0   ⋅    ⋅
  6.0  1.0   ⋅
 -8.0  5.0  3.0

julia> C.L * C.U == A
true

julia> l, u = C; # 反復による分解

julia> l == C.L && u == C.U
true
```

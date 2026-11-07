```julia
Cholesky <: Factorization
```

密な対称正定値／エルミート正定値行列 `A` のコレスキー分解における行列分解型です。対応する行列分解関数 [`cholesky`](@ref) の戻り値の型です。

三角コレスキー因子は、分解 `F::Cholesky` から `F.L` および `F.U` を使って取得できます。このとき、`A ≈ F.U' * F.U ≈ F.L * F.L'` です。

`Cholesky` オブジェクトでは、次の関数を利用できます。[`size`](@ref)、[`\`](@ref)、[`inv`](@ref)、[`det`](@ref)、[`logdet`](@ref)、[`isposdef`](@ref)。

分解を反復処理すると、成分 `L` と `U` が得られます。

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

julia> l, u = C; # destructuring via iteration

julia> l == C.L && u == C.U
true
```

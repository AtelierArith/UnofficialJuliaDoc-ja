```julia
bunchkaufman(A, rook::Bool=false; check = true) -> S::BunchKaufman
```

対称行列またはエルミート行列 `A` の Bunch-Kaufman 分解[^Bunch1977]を計算します。`A` に格納されている三角部分に応じて、`P'*U*D*U'*P` または `P'*L*D*L'*P` として分解し、[`BunchKaufman`](@ref) オブジェクトを返します。ここで、`U` と `L` はそれぞれ上三角行列と下三角行列、`P` は置換行列、`D` は 1×1 および 2×2 ブロックからなるブロック対角行列です。`A` が複素対称行列の場合、`U'` と `L'` は共役を取らない転置を表し、すなわち `transpose(U)` と `transpose(L)` であることに注意してください。

分解を反復すると、`S.uplo` に応じて、`S.D`、`S.U` または `S.L`、および `S.p` が得られます。

`rook` が `true` の場合、ルークピボット法が使用されます。`rook` が false の場合、ルークピボット法は使用されません。

`check = true` の場合、分解に失敗するとエラーがスローされます。`check = false` の場合、分解が有効かどうかの確認（[`issuccess`](@ref) による）はユーザーの責任です。

`BunchKaufman` オブジェクトでは、次の関数を使用できます: [`size`](@ref)、`\`、[`inv`](@ref)、[`issymmetric`](@ref)、[`ishermitian`](@ref)、[`getindex`](@ref)。

[^Bunch1977]: J R Bunch and L Kaufman, Some stable methods for calculating inertia and solving symmetric linear systems, Mathematics of Computation 31:137 (1977), 163-179. [url](https://www.ams.org/journals/mcom/1977-31-137/S0025-5718-1977-0428694-0/).

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

julia> S.U * S.D * S.U' ≈ S.P * A * S.P'
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

julia> S.L * S.D * S.L' ≈ A[S.p, S.p]
true
```

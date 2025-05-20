```
bunchkaufman(A, rook::Bool=false; check = true) -> S::BunchKaufman
```

対称行列またはエルミート行列 `A` のバンチ-カウフマン [^Bunch1977] 分解を `P'*U*D*U'*P` または `P'*L*D*L'*P` として計算し、`A` に格納されている三角形に応じて [`BunchKaufman`](@ref) オブジェクトを返します。`A` が複素対称の場合、`U'` と `L'` は共役でない転置を示します。すなわち、`transpose(U)` と `transpose(L)` です。

分解を繰り返すことで、`S.uplo` に応じて適切なコンポーネント `S.D`、`S.U` または `S.L`、および `S.p` を生成します。

`rook` が `true` の場合、ルークピボッティングが使用されます。`rook` が false の場合、ルークピボッティングは使用されません。

`check = true` の場合、分解が失敗した場合にエラーがスローされます。`check = false` の場合、分解の有効性を確認する責任はユーザーにあります（[`issuccess`](@ref) を介して）。

`BunchKaufman` オブジェクトに対して利用可能な関数は次のとおりです: [`size`](@ref), `\`, [`inv`](@ref), [`issymmetric`](@ref), [`ishermitian`](@ref), [`getindex`](@ref).

[^Bunch1977]: J R Bunch と L Kaufman, 一部の安定した方法による慣性の計算と対称線形システムの解法, Mathematics of Computation 31:137 (1977), 163-179. [url](https://www.ams.org/journals/mcom/1977-31-137/S0025-5718-1977-0428694-0/).

# 例

```jldoctest
julia> A = Float64.([1 2; 2 3])
2×2 Matrix{Float64}:
 1.0  2.0
 2.0  3.0

julia> S = bunchkaufman(A) # A は内部で Symmetric(A) にラップされます
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

julia> d, u, p = S; # 繰り返しによる分解

julia> d == S.D && u == S.U && p == S.p
true

julia> S.U*S.D*S.U' - S.P*A*S.P'
2×2 Matrix{Float64}:
 0.0  0.0
 0.0  0.0

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

julia> S.L*S.D*S.L' - A[S.p, S.p]
2×2 Matrix{Float64}:
 0.0  0.0
 0.0  0.0
```

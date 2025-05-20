```
lq(A) -> S::LQ
```

行列 `A` の LQ 分解を計算します。分解の下三角成分は、[`LQ`](@ref) オブジェクト `S` から `S.L` を介して取得でき、直交/ユニタリ成分は `S.Q` を介して取得できるため、`A ≈ S.L*S.Q` となります。

分解を繰り返すことで、成分 `S.L` と `S.Q` を得ることができます。

LQ 分解は `transpose(A)` の QR 分解であり、行数よりも列数が多いが行ランクが完全な方程式系に対して最小ノルム解 `lq(A) \ b` を計算するために有用です。

# 例

```jldoctest
julia> A = [5. 7.; -2. -4.]
2×2 Matrix{Float64}:
  5.0   7.0
 -2.0  -4.0

julia> S = lq(A)
LQ{Float64, Matrix{Float64}, Vector{Float64}}
L 因子:
2×2 Matrix{Float64}:
 -8.60233   0.0
  4.41741  -0.697486
Q 因子: 2×2 LinearAlgebra.LQPackedQ{Float64, Matrix{Float64}, Vector{Float64}}

julia> S.L * S.Q
2×2 Matrix{Float64}:
  5.0   7.0
 -2.0  -4.0

julia> l, q = S; # 繰り返しによる分解

julia> l == S.L &&  q == S.Q
true
```

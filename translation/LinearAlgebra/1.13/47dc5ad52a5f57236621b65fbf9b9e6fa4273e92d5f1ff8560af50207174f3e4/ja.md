```julia
lq(A) -> S::LQ
```

`A` の LQ 分解を計算します。分解の下三角成分は、[`LQ`](@ref) オブジェクト `S` から `S.L` を使って取得でき、直交／ユニタリ成分は `S.Q` を使って取得できます。このとき、`A ≈ S.L*S.Q` となります。

分解を反復すると、成分 `S.L` と `S.Q` が得られます。

LQ 分解は `transpose(A)` の QR 分解であり、劣決定系の方程式（`A` は行数より列数が多いものの、行フルランクである）の最小ノルム解 `lq(A) \ b` を求めるのに役立ちます。

# Examples

```jldoctest
julia> A = [5. 7.; -2. -4.]
2×2 Matrix{Float64}:
  5.0   7.0
 -2.0  -4.0

julia> S = lq(A)
LQ{Float64, Matrix{Float64}, Vector{Float64}}
L factor:
2×2 Matrix{Float64}:
 -8.60233   0.0
  4.41741  -0.697486
Q factor: 2×2 LinearAlgebra.LQPackedQ{Float64, Matrix{Float64}, Vector{Float64}}

julia> S.L * S.Q
2×2 Matrix{Float64}:
  5.0   7.0
 -2.0  -4.0

julia> l, q = S; # destructuring via iteration

julia> l == S.L &&  q == S.Q
true
```

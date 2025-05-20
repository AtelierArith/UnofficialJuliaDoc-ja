```
LQ <: Factorization
```

行列 `A` の `LQ` 分解の行列因子化タイプです。`LQ` 分解は、`transpose(A)` の [`QR`](@ref) 分解です。これは、対応する行列因子化関数 [`lq`](@ref) の戻り値の型です。

`S::LQ` が因子化オブジェクトである場合、下三角成分は `S.L` を介して取得でき、直交/ユニタリ成分は `S.Q` を介して取得できるため、`A ≈ S.L*S.Q` となります。

分解を反復することで、成分 `S.L` と `S.Q` が得られます。

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

julia> l, q = S; # 反復による分解

julia> l == S.L &&  q == S.Q
true
```

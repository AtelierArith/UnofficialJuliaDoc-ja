```julia
LQ <: Factorization
```

行列 `A` の `LQ` 分解の行列分解型です。`LQ` 分解は、`transpose(A)` の [`QR`](@ref) 分解です。これは、対応する行列分解関数 [`lq`](@ref) の戻り値の型です。

`S::LQ` が分解オブジェクトの場合、下三角成分は `S.L` で、直交／ユニタリ成分は `S.Q` で取得できます。このとき、`A ≈ S.L*S.Q` となります。

この分解を反復処理すると、成分 `S.L` と `S.Q` が得られます。

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

```julia
GeneralizedSVD <: Factorization
```

2つの行列 `A` と `B` の一般化特異値分解（SVD）を表す行列因子分解型です。`A = F.U*F.D1*F.R0*F.Q'` と `B = F.V*F.D2*F.R0*F.Q'` を満たします。これは、対応する行列因子分解関数 [`svd(_, _)`](@ref) の戻り値の型です。

M×N 行列 `A` と P×N 行列 `B` に対して、

  * `U` は M×M の直交行列です。
  * `V` は P×P の直交行列です。
  * `Q` は N×N の直交行列です。
  * `D1` は M×(K+L) の対角行列で、最初の K 個の要素は 1 です。
  * `D2` は P×(K+L) の行列で、右上の L×L ブロックは対角行列です。
  * `R0` は (K+L)×N の行列で、右端の (K+L)×(K+L) ブロックは正則な上三角ブロック行列です。

`K+L` は、行列 `[A; B]` の実効数値ランクです。

分解を反復すると、成分 `U`、`V`、`Q`、`D1`、`D2`、`R0` が得られます。

`F.D1` と `F.D2` の要素の関係については、内部で呼び出される [generalized SVD](https://www.netlib.org/lapack/lug/node36.html) および [xGGSVD3](https://www.netlib.org/lapack/explore-html/d6/db3/dggsvd3_8f.html) ルーチンの LAPACK ドキュメント（LAPACK 3.6.0 以降）を参照してください。

# Examples

```jldoctest
julia> A = [1. 0.; 0. -1.]
2×2 Matrix{Float64}:
 1.0   0.0
 0.0  -1.0

julia> B = [0. 1.; 1. 0.]
2×2 Matrix{Float64}:
 0.0  1.0
 1.0  0.0

julia> F = svd(A, B)
GeneralizedSVD{Float64, Matrix{Float64}, Float64, Vector{Float64}}
U factor:
2×2 Matrix{Float64}:
 1.0  0.0
 0.0  1.0
V factor:
2×2 Matrix{Float64}:
 -0.0  -1.0
  1.0   0.0
Q factor:
2×2 Matrix{Float64}:
 1.0  0.0
 0.0  1.0
D1 factor:
2×2 Matrix{Float64}:
 0.707107  0.0
 0.0       0.707107
D2 factor:
2×2 Matrix{Float64}:
 0.707107  0.0
 0.0       0.707107
R0 factor:
2×2 Matrix{Float64}:
 1.41421   0.0
 0.0      -1.41421

julia> F.U*F.D1*F.R0*F.Q'
2×2 Matrix{Float64}:
 1.0   0.0
 0.0  -1.0

julia> F.V*F.D2*F.R0*F.Q'
2×2 Matrix{Float64}:
 -0.0  1.0
  1.0  0.0
```

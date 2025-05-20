```
GeneralizedSVD <: Factorization
```

2つの行列 `A` と `B` の一般化特異値分解 (SVD) の行列因子化タイプであり、`A = F.U*F.D1*F.R0*F.Q'` および `B = F.V*F.D2*F.R0*F.Q'` となります。これは [`svd(_, _)`](@ref) の戻り値の型であり、対応する行列因子化関数です。

M×N 行列 `A` と P×N 行列 `B` に対して、

  * `U` は M×M の直交行列です。
  * `V` は P×P の直交行列です。
  * `Q` は N×N の直交行列です。
  * `D1` は最初の K エントリに 1 がある M×(K+L) の対角行列です。
  * `D2` は上部右の L×L ブロックが対角である P×(K+L) の行列です。
  * `R0` は最も右の (K+L)×(K+L) ブロックが非特異上三角である (K+L)×N の行列です。

`K+L` は行列 `[A; B]` の有効数値ランクです。

分解を繰り返すことで、成分 `U`、`V`、`Q`、`D1`、`D2`、および `R0` が生成されます。

`F.D1` と `F.D2` のエントリは関連しており、[一般化 SVD](https://www.netlib.org/lapack/lug/node36.html) の LAPACK ドキュメントおよびその下で呼び出される [xGGSVD3](https://www.netlib.org/lapack/explore-html/d6/db3/dggsvd3_8f.html) ルーチンで説明されています (LAPACK 3.6.0 以降)。

# 例

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

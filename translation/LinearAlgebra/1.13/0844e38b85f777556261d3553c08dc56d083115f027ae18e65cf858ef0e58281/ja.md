```julia
pinv(M; atol::Real=0, rtol::Real=atol>0 ? 0 : n*ϵ)
pinv(M, rtol::Real) = pinv(M; rtol=rtol) # to be deprecated in Julia 2.0
```

ムーア・ペンローズ擬似逆行列を計算します。

浮動小数点要素を持つ行列 `M` では、`σ₁` が `M` の最大特異値であるとき、`max(atol, rtol*σ₁)` より大きい特異値だけを逆数にすることで、擬似逆行列を効率よく計算できます。

絶対許容誤差（`atol`）と相対許容誤差（`rtol`）の最適な値は、`M` の値と擬似逆行列の用途の両方によって異なります。相対許容誤差の既定値は `n*ϵ` です。ここで、`n` は `M` の最小次元のサイズ、`ϵ` は `M` の要素型の [`eps`](@ref) です。

密で悪条件な方程式を最小二乗の意味で解く場合、擬似逆行列を明示的に作成するのは避けるのが望ましいです。許容誤差が小さいと、数値的に不安定になる可能性があるためです。既定の `M \ b` アルゴリズムでは、代わりにピボット付き QR 分解（[`qr`](@ref)）を使用します。SVD に基づくアルゴリズムを使う場合は、`svd(M; rtol, atol) \ b` または `ldiv!(svd(M), b; rtol, atol)` を使って SVD を直接利用するのが望ましいです。

既存の [`SVD`](@ref) 分解を再利用するには、`pinv` の引数として `M = svd(A)` を渡すこともできます。この場合、`pinv` は明示的な行列ではなく、正確に適用できる擬似逆行列の SVD を返します。

!!! compat "Julia 1.13"
    `SVD` オブジェクトを `pinv` に渡すには、Julia 1.13 以降が必要です。


詳細については、[^pr1387]、[^B96]、[^S84]、[^KY88]を参照してください。

# Examples

```jldoctest
julia> M = [1.5 1.3; 1.2 1.9]
2×2 Matrix{Float64}:
 1.5  1.3
 1.2  1.9

julia> N = pinv(M)
2×2 Matrix{Float64}:
  1.47287   -1.00775
 -0.930233   1.16279

julia> M * N
2×2 Matrix{Float64}:
 1.0          -2.22045e-16
 4.44089e-16   1.0
```

[^pr1387]: PR 1387, "stable pinv least-squares", [LinearAlgebra.jl#1387](https://github.com/JuliaLang/LinearAlgebra.jl/pull/1387)

[^B96]: Åke Björck, "Numerical Methods for Least Squares Problems",  SIAM Press, Philadelphia, 1996, "Other Titles in Applied Mathematics", Vol. 51. [doi:10.1137/1.9781611971484](http://epubs.siam.org/doi/book/10.1137/1.9781611971484)

[^S84]: G. W. Stewart, "Rank Degeneracy", SIAM Journal on Scientific and Statistical Computing, 5(2), 1984, 403-413. [doi:10.1137/0905030](http://epubs.siam.org/doi/abs/10.1137/0905030)

[^KY88]: Konstantinos Konstantinides and Kung Yao, "Statistical analysis of effective singular values in matrix rank determination", IEEE Transactions on Acoustics, Speech and Signal Processing, 36(5), 1988, 757-763. [doi:10.1109/29.1585](https://doi.org/10.1109/29.1585)

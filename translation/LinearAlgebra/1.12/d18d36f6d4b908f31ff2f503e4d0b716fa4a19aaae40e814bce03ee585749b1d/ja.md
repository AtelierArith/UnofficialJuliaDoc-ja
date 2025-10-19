```julia
pinv(M; atol::Real=0, rtol::Real=atol>0 ? 0 : n*ϵ)
pinv(M, rtol::Real) = pinv(M; rtol=rtol) # to be deprecated in Julia 2.0
```

ムーア・ペンローズ擬似逆行列を計算します。

浮動小数点要素を持つ行列 `M` に対しては、`σ₁` が `M` の最大特異値であるとき、`max(atol, rtol*σ₁)` より大きい特異値のみを反転することによって擬似逆行列を計算することが便利です。

絶対許容誤差（`atol`）と相対許容誤差（`rtol`）の最適な選択は、`M` の値と擬似逆行列の意図された用途によって異なります。デフォルトの相対許容誤差は `n*ϵ` であり、ここで `n` は `M` の最小次元のサイズ、`ϵ` は `M` の要素型の [`eps`](@ref) です。

最小二乗法の意味で密な条件の悪い行列を反転する場合、`rtol = sqrt(eps(real(float(oneunit(eltype(M))))))` が推奨されます。

詳細については、[^\issue8859]、[^\B96]、[^\S84]、[^\KY88] を参照してください。

# 例

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

[^issue8859]: Issue 8859, "Fix least squares", [https://github.com/JuliaLang/julia/pull/8859](https://github.com/JuliaLang/julia/pull/8859)

[^B96]: Åke Björck, "Numerical Methods for Least Squares Problems",  SIAM Press, Philadelphia, 1996, "Other Titles in Applied Mathematics", Vol. 51. [doi:10.1137/1.9781611971484](http://epubs.siam.org/doi/book/10.1137/1.9781611971484)

[^S84]: G. W. Stewart, "Rank Degeneracy", SIAM Journal on Scientific and Statistical Computing, 5(2), 1984, 403-413. [doi:10.1137/0905030](http://epubs.siam.org/doi/abs/10.1137/0905030)

[^KY88]: Konstantinos Konstantinides and Kung Yao, "Statistical analysis of effective singular values in matrix rank determination", IEEE Transactions on Acoustics, Speech and Signal Processing, 36(5), 1988, 757-763. [doi:10.1109/29.1585](https://doi.org/10.1109/29.1585)

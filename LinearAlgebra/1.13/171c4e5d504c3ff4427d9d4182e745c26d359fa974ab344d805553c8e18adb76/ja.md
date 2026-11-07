```julia
log(A::AbstractMatrix)
```

`A` が負の実固有値を持たない場合、`A` の主行列対数を計算します。すなわち、``e^X = A`` を満たし、かつ ``X`` のすべての固有値 ``\lambda`` に対して ``-\pi < Im(\lambda) < \pi`` を満たす一意な行列 ``X`` を求めます。`A` が非正の固有値を持つ場合は、可能であれば主値ではない行列関数を返します。

`A` が対称行列またはエルミート行列の場合は、固有値分解（[`eigen`](@ref)）を使用します。`A` が三角行列の場合は、逆スケーリング・二乗法の改良版を使用します（[^AH12] および [^AHR13] を参照）。`A` が実行列で、負の固有値を持たない場合は、実 Schur 形を計算します。それ以外の場合は、複素 Schur 形を計算します。その後、上（準）三角因子に対して、[^AHR13] の上（準）三角行列用アルゴリズムを適用します。

[^AH12]: Awad H. Al-Mohy および Nicholas J. Higham、「行列対数のための改良型逆スケーリング・二乗アルゴリズム」、SIAM Journal on Scientific Computing, 34(4), 2012, C153-C169. [doi:10.1137/110852553](https://doi.org/10.1137/110852553)

[^AHR13]: Awad H. Al-Mohy、Nicholas J. Higham および Samuel D. Relton、「行列対数の Fréchet 微分の計算と条件数の推定」、SIAM Journal on Scientific Computing, 35(4), 2013, C394-C410. [doi:10.1137/120885991](https://doi.org/10.1137/120885991)

# Examples

```jldoctest
julia> A = Matrix(2.7182818*I, 2, 2)
2×2 Matrix{Float64}:
 2.71828  0.0
 0.0      2.71828

julia> log(A)
2×2 Matrix{Float64}:
 1.0  0.0
 0.0  1.0
```

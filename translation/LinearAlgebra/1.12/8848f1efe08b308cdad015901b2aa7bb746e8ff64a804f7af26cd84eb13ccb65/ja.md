```julia
log(A::AbstractMatrix)
```

もし `A` に負の実固有値がない場合、`A` の主行列対数を計算します。すなわち、$e^X = A$ であり、すべての固有値 $\lambda$ に対して $-\pi < Im(\lambda) < \pi$ となる唯一の行列 $X$ を求めます。もし `A` に非正の固有値がある場合、可能な限り非主行列関数が返されます。

`A` が対称またはエルミートの場合、その固有分解（[`eigen`](@ref)）が使用され、`A` が三角行列の場合は、逆スケーリングと平方根法の改良版が使用されます（[^\AH12] および [^\AHR13] を参照）。もし `A` が負の固有値を持たない実数の場合、実シュア形式が計算されます。そうでない場合、複素シュア形式が計算されます。その後、[^\AHR13] の上部（準）三角アルゴリズムが上部（準）三角因子に対して使用されます。

[^\AH12]: Awad H. Al-Mohy と Nicholas J. Higham, "Improved inverse scaling and squaring algorithms for the matrix logarithm", SIAM Journal on Scientific Computing, 34(4), 2012, C153-C169. [doi:10.1137/110852553](https://doi.org/10.1137/110852553)

[^\AHR13]: Awad H. Al-Mohy, Nicholas J. Higham と Samuel D. Relton, "Computing the Fréchet derivative of the matrix logarithm and estimating the condition number", SIAM Journal on Scientific Computing, 35(4), 2013, C394-C410. [doi:10.1137/120885991](https://doi.org/10.1137/120885991)

# 例

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

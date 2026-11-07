```julia
exp(A::AbstractMatrix)
```

`A` の行列指数関数を、次のように定義して計算します。

```math
e^A = \sum_{n=0}^{\infty} \frac{A^n}{n!}.
```

対称またはエルミートな `A` には固有分解（[`eigen`](@ref)）を使用し、それ以外の場合はスケーリング・二乗法（[^H05] を参照）を選択します。

[^H05]: Nicholas J. Higham, "The squaring and scaling method for the matrix exponential revisited", SIAM Journal on Matrix Analysis and Applications, 26(4), 2005, 1179-1193. [doi:10.1137/090768539](https://doi.org/10.1137/090768539)

# Examples

```jldoctest
julia> A = Matrix(1.0I, 2, 2)
2×2 Matrix{Float64}:
 1.0  0.0
 0.0  1.0

julia> exp(A)
2×2 Matrix{Float64}:
 2.71828  0.0
 0.0      2.71828
```

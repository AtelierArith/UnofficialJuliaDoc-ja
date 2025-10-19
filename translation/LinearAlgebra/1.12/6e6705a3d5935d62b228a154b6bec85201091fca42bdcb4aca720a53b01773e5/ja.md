```julia
exp(A::AbstractMatrix)
```

行列 `A` の行列指数関数を計算します。定義は次の通りです。

$$
e^A = \sum_{n=0}^{\infty} \frac{A^n}{n!}.
$$

対称行列またはエルミート行列 `A` の場合は、固有分解（[`eigen`](@ref)）が使用され、それ以外の場合はスケーリングと平方化アルゴリズムが選択されます（[^\H05]を参照）。

[^H05]: Nicholas J. Higham, "The squaring and scaling method for the matrix exponential revisited", SIAM Journal on Matrix Analysis and Applications, 26(4), 2005, 1179-1193. [doi:10.1137/090768539](https://doi.org/10.1137/090768539)

# 例

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

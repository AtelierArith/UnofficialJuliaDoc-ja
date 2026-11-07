```julia
asin(A::AbstractMatrix)
```

正方行列 `A` の逆正弦を計算します。

`A` が実対称行列またはエルミート行列の場合は、その固有値分解（[`eigen`](@ref)）を使って逆正弦を計算します。それ以外の場合は、[`log`](@ref) と [`sqrt`](@ref) を使って逆正弦を求めます。この関数の計算に用いる理論と対数公式については、[^AH16_2] を参照してください。

[^AH16_2]: Mary Aprahamian and Nicholas J. Higham, "Matrix Inverse Trigonometric and Inverse Hyperbolic Functions: Theory and Algorithms", MIMS EPrint: 2016.4. [https://doi.org/10.1137/16M1057577](https://doi.org/10.1137/16M1057577)

# Examples

```julia-repl
julia> asin(sin([0.5 0.1; -0.2 0.3]))
2×2 Matrix{ComplexF64}:
  0.5-4.16334e-17im  0.1-5.55112e-17im
 -0.2+9.71445e-17im  0.3-1.249e-16im
```

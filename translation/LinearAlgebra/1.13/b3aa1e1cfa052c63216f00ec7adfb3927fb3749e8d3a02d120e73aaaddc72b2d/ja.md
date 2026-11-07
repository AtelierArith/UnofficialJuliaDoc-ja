```julia
atan(A::AbstractMatrix)
```

正方行列 `A` の逆正接行列を計算します。

`A` が実対称行列またはエルミート行列の場合、逆正接の計算には固有値分解（[`eigen`](@ref)）を使用します。それ以外の場合は、[`log`](@ref) を使用して逆正接を求めます。この関数の計算に用いる理論と対数公式については、[^AH16_3] を参照してください。

[^AH16_3]: Mary Aprahamian and Nicholas J. Higham, "Matrix Inverse Trigonometric and Inverse Hyperbolic Functions: Theory and Algorithms", MIMS EPrint: 2016.4. [https://doi.org/10.1137/16M1057577](https://doi.org/10.1137/16M1057577)

# Examples

```julia-repl
julia> atan(tan([0.5 0.1; -0.2 0.3]))
2×2 Matrix{ComplexF64}:
  0.5  0.1
 -0.2  0.3
```

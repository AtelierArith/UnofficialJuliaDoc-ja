```julia
acos(A::AbstractMatrix)
```

正方行列 `A` の逆行列コサインを計算します。

`A` が対称またはエルミートの場合、その固有分解（[`eigen`](@ref)）を使用して逆コサインを計算します。そうでない場合、逆コサインは [`log`](@ref) と [`sqrt`](@ref) を使用して決定されます。この関数を計算するために使用される理論と対数式については、[^AH16_1] を参照してください。

[^AH16_1]: Mary Aprahamian and Nicholas J. Higham, "Matrix Inverse Trigonometric and Inverse Hyperbolic Functions: Theory and Algorithms", MIMS EPrint: 2016.4. [https://doi.org/10.1137/16M1057577](https://doi.org/10.1137/16M1057577)

# 例

```julia-repl
julia> acos(cos([0.5 0.1; -0.2 0.3]))
2×2 Matrix{ComplexF64}:
  0.5-8.32667e-17im  0.1+0.0im
 -0.2+2.63678e-16im  0.3-3.46945e-16im
```

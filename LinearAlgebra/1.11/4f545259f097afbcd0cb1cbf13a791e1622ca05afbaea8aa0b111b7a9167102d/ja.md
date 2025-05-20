```
atan(A::AbstractMatrix)
```

正方行列 `A` の逆行列タンジェントを計算します。

`A` が対称またはエルミートの場合、その固有分解（[`eigen`](@ref)）を使用して逆タンジェントを計算します。そうでない場合、逆タンジェントは [`log`](@ref) を使用して決定されます。この関数を計算するために使用される理論と対数式については、[^AH16_3] を参照してください。

[^AH16_3]: Mary Aprahamian と Nicholas J. Higham, "Matrix Inverse Trigonometric and Inverse Hyperbolic Functions: Theory and Algorithms", MIMS EPrint: 2016.4. [https://doi.org/10.1137/16M1057577](https://doi.org/10.1137/16M1057577)

# 例

```julia-repl
julia> atan(tan([0.5 0.1; -0.2 0.3]))
2×2 Matrix{ComplexF64}:
  0.5+1.38778e-17im  0.1-2.77556e-17im
 -0.2+6.93889e-17im  0.3-4.16334e-17im
```

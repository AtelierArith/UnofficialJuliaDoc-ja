```
asin(A::AbstractMatrix)
```

正方行列 `A` の逆行列サインを計算します。

`A` が対称行列またはエルミート行列である場合、その固有分解（[`eigen`](@ref)）を使用して逆サインを計算します。そうでない場合、逆サインは [`log`](@ref) と [`sqrt`](@ref) を使用して決定されます。この関数を計算するために使用される理論と対数式については、[^AH16_2] を参照してください。

[^AH16_2]: Mary Aprahamian と Nicholas J. Higham, "Matrix Inverse Trigonometric and Inverse Hyperbolic Functions: Theory and Algorithms", MIMS EPrint: 2016.4. [https://doi.org/10.1137/16M1057577](https://doi.org/10.1137/16M1057577)

# 例

```julia-repl
julia> asin(sin([0.5 0.1; -0.2 0.3]))
2×2 Matrix{ComplexF64}:
  0.5-4.16334e-17im  0.1-5.55112e-17im
 -0.2+9.71445e-17im  0.3-1.249e-16im
```

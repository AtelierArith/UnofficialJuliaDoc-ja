```julia
givens(x::AbstractVector, i1::Integer, i2::Integer) -> (G::Givens, r)
```

Givens回転`G`とスカラー`r`を計算します。これにより、乗算の結果が

```julia
B = G*x
```

次の性質を持つようになります。

```julia
B[i1] = r
B[i2] = 0
```

詳細については[`LinearAlgebra.Givens`](@ref)を参照してください。 ```

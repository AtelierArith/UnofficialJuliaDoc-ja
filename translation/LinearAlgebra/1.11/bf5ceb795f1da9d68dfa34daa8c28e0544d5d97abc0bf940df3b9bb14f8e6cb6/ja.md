```
givens(x::AbstractVector, i1::Integer, i2::Integer) -> (G::Givens, r)
```

Givens回転`G`とスカラー`r`を計算します。これにより、乗算の結果が

```
B = G*x
```

次の性質を持つようになります。

```
B[i1] = r
B[i2] = 0
```

詳細は[`LinearAlgebra.Givens`](@ref)を参照してください。 ```

```
givens(A::AbstractArray, i1::Integer, i2::Integer, j::Integer) -> (G::Givens, r)
```

Givens回転`G`とスカラー`r`を計算します。これにより、掛け算の結果が

```
B = G*A
```

次の性質を持つようになります。

```
B[i1,j] = r
B[i2,j] = 0
```

詳細は[`LinearAlgebra.Givens`](@ref)を参照してください。 ```

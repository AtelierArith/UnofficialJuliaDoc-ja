```julia
givens(f::T, g::T, i1::Integer, i2::Integer) where {T} -> (G::Givens, r::T)
```

Givens回転`G`とスカラー`r`を計算します。これは、任意のベクトル`x`に対して次のようになります。

```julia
x[i1] = f
x[i2] = g
```

乗算の結果

```julia
y = G*x
```

は次の性質を持ちます。

```julia
y[i1] = r
y[i2] = 0
```

詳細は[`LinearAlgebra.Givens`](@ref)を参照してください。

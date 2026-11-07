```julia
givens(f::T, g::T, i1::Integer, i2::Integer) where {T} -> (G::Givens, r::T)
```

Givens 回転 `G` とスカラー `r` を計算します。これらは、次の条件を満たす任意のベクトル `x` に対して、以下に示す性質を持ちます。

```julia
x[i1] = f
x[i2] = g
```

次の乗算の結果は、

```julia
y = G*x
```

次の性質を満たします。

```julia
y[i1] = r
y[i2] = 0
```

[`LinearAlgebra.Givens`](@ref) も参照してください。

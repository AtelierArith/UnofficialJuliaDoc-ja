```julia
givens(f::T, g::T, i1::Integer, i2::Integer) where {T} -> (G::Givens, r::T)
```

任意のベクトル `x` に対して、次の条件が成り立つようなギブンス回転 `G` とスカラー `r` を計算します。

```julia
x[i1] = f
x[i2] = g
```

積

```julia
y = G*x
```

の結果が次の性質を持つようにします。

```julia
y[i1] = r
y[i2] = 0
```

[`LinearAlgebra.Givens`](@ref) も参照してください。

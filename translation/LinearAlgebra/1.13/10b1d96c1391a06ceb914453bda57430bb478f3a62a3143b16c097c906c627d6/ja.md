```julia
givens(x::AbstractVector, i1::Integer, i2::Integer) -> (G::Givens, r)
```

積の結果が次の性質を満たすような、ギブンス回転 `G` とスカラー `r` を計算します。

```julia
B = G*x
```

つまり、

```julia
B[i1] = r
B[i2] = 0
```

となります。関連項目: [`LinearAlgebra.Givens`](@ref)。

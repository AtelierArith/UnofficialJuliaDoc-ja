```julia
givens(A::AbstractArray, i1::Integer, i2::Integer, j::Integer) -> (G::Givens, r)
```

ギブンス回転 `G` とスカラー `r` を計算します。これらは、次の積の結果が

```julia
B = G*A
```

次の性質を満たすように選ばれます。

```julia
B[i1,j] = r
B[i2,j] = 0
```

関連項目: [`LinearAlgebra.Givens`](@ref)。

```julia
Base.mul_prod(x, y)
```

`prod`で使用される縮約演算子です。[`*`](@ref)との主な違いは、小さな整数が`Int`/`UInt`に昇格される点です。

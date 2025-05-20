```
swapproperty!(x, f::Symbol, v, order::Symbol=:not_atomic)
```

構文 `@atomic a.b, _ = c, a.b` は `(c, swapproperty!(a, :b, c, :sequentially_consistent))` を返します。このとき、両側に共通する `getproperty` 式が1つ必要です。

また、[`swapfield!`](@ref Core.swapfield!) と [`setproperty!`](@ref Base.setproperty!) も参照してください。

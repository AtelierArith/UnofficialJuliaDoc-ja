```julia
swapproperty!(x, f::Symbol, v, order::Symbol=:not_atomic)
```

`@atomic a.b, _ = c, a.b` の構文は `(c, swapproperty!(a, :b, c, :sequentially_consistent))` を返します。このとき、両辺に共通する `getproperty` 式が1つ必要です。

[`swapfield!`](@ref Core.swapfield!) および [`setproperty!`](@ref Base.setproperty!) も参照してください。

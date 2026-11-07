```julia
@_safeindex
```

この内部マクロは、次のように変換します。

  * `getindex(xs::Tuple, i::Int)` -> `__safe_getindex(xs, i)`
  * `setindex!(xs::Vector{T}, x, i::Int)` -> `__safe_setindex!(xs, x, i)`

これにより、適用対象の式内のインデックス操作は常に範囲内であり、`:consistent` と `:nothrow` を汚染する必要がないことをコンパイラに伝えます。

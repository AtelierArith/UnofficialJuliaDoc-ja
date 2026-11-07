```julia
root_union!(s::IntDisjointSet{T}, x::T, y::T)
```

ルート要素が `x` と `y` である2つの集合の和集合となる新しい集合を作成し、そのルートを返します。`x ≠ y`（安全ではない）と仮定します。

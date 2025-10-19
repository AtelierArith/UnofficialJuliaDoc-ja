```julia
push!(s::IntDisjointSet{T})
```

自動的に選択された新しい要素 `x` を持つ新しい部分集合を作成します。新しい要素を返します。集合の容量を超える場合は `ArgumentError` をスローします。

```julia
push!(s::IntDisjointSet{T})
```

新しい要素 `x` を自動的に選択して、新しい部分集合を作成します。新しい要素を返します。集合の容量を超える場合は `ArgumentError` をスローします。

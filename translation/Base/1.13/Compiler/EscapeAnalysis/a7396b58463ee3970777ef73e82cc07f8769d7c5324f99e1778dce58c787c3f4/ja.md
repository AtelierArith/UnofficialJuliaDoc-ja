```julia
IntDisjointSet{T<:Integer}(n::Integer)
```

互いに素な整数集合の森。これは、要素の集合を複数の互いに素（重複しない）な部分集合に分割して管理するデータ構造です（union–find データ構造、または merge–find set とも呼ばれます）。

```julia
IntDisjointSet{T<:Integer}(n::Integer)
```

整数の互いに素な集合からなる森。これは、要素の集合を複数の互いに素な（重複しない）部分集合に分割して管理するデータ構造です（union–find データ構造、または merge–find set とも呼ばれます）。

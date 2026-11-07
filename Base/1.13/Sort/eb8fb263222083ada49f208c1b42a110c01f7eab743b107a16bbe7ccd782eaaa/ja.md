```julia
BoolOptimization(next) isa Base.Sort.Algorithm
```

計数ソートを特殊化した方法で`AbstractVector{Bool}`をソートします。

各要素へのアクセスは最大2回（読み取り1回、書き込み1回）で、比較は最大2回行います。

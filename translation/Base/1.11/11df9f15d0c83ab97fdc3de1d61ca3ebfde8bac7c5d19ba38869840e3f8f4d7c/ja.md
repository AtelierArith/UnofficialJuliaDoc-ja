```
NTuple{N, T}
```

長さ `N` のタプルの型を表すコンパクトな方法で、すべての要素は型 `T` です。

# 例

```jldoctest
julia> isa((1, 2, 3, 4, 5, 6), NTuple{6, Int})
true
```

関連項目として [`ntuple`](@ref) を参照してください。

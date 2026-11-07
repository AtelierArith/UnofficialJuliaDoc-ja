```julia
isempty(collection)::Bool
```

コレクションが空（要素を持たない）かどうかを判定します。

!!! warning
    `isempty(itr)` は、適切な [`Base.isdone(itr)`](@ref) メソッドが定義されていない場合、状態を持つイテレータ `itr` の次の要素を消費することがあります。状態を持つイテレータでは `isdone` を実装することが推奨されますが、あらゆる型のイテレータに対応する汎用コードを書く場合は、`isempty` の使用を避けたほうがよいでしょう。


# Examples

```jldoctest
julia> isempty([])
true

julia> isempty([1 2 3])
false
```

```
values(a::AbstractDict)
```

コレクション内のすべての値に対するイテレータを返します。 `collect(values(a))` は値の配列を返します。値が内部的にハッシュテーブルに格納されている場合、`Dict` のように、返される順序は異なる場合があります。しかし、`keys(a)`、`values(a)` および `pairs(a)` はすべて `a` をイテレートし、同じ順序で要素を返します。

# 例

```jldoctest
julia> D = Dict('a'=>2, 'b'=>3)
Dict{Char, Int64} with 2 entries:
  'a' => 2
  'b' => 3

julia> collect(values(D))
2-element Vector{Int64}:
 2
 3
```

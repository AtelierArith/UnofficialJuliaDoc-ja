```
keys(a::AbstractDict)
```

辞書内のすべてのキーに対するイテレータを返します。 `collect(keys(a))` はキーの配列を返します。キーが内部的にハッシュテーブルに格納されている場合（`Dict` の場合など）、返される順序は異なる場合があります。しかし、`keys(a)`、`values(a)` および `pairs(a)` はすべて `a` をイテレートし、同じ順序で要素を返します。

# 例

```jldoctest
julia> D = Dict('a'=>2, 'b'=>3)
Dict{Char, Int64} with 2 entries:
  'a' => 2
  'b' => 3

julia> collect(keys(D))
2-element Vector{Char}:
 'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)
 'b': ASCII/Unicode U+0062 (category Ll: Letter, lowercase)
```

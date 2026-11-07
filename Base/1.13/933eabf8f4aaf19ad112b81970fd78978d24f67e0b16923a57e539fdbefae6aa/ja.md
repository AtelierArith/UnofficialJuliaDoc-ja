```julia
keys(a::AbstractDict)
```

辞書内のすべてのキーを反復処理するイテレーターを返します。`collect(keys(a))`はキーの配列を返します。`Dict`のように、キーが内部的にハッシュテーブルに格納されている場合、返される順序は変わることがあります。一方、`keys(a)`、`values(a)`、`pairs(a)`はいずれも`a`を反復処理し、同じ順序で要素を返します。

# Examples

```jldoctest; filter = r"^\s+'\S'.*$"m
julia> D = Dict('a'=>2, 'b'=>3)
Dict{Char, Int64} with 2 entries:
  'a' => 2
  'b' => 3

julia> collect(keys(D))
2-element Vector{Char}:
 'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)
 'b': ASCII/Unicode U+0062 (category Ll: Letter, lowercase)
```

```julia
values(a::AbstractDict)
```

コレクション内のすべての値を反復処理するイテレーターを返します。`collect(values(a))` は値の配列を返します。`Dict` のように、値が内部的にハッシュテーブルに格納されている場合、返される順序は変わることがあります。一方、`keys(a)`、`values(a)`、`pairs(a)` はいずれも `a` を反復処理し、同じ順序で要素を返します。

# Examples

```jldoctest; filter = r"^\s+\S+(\s+=>\s+\d)?$"m
julia> D = Dict('a'=>2, 'b'=>3)
Dict{Char, Int64} with 2 entries:
  'a' => 2
  'b' => 3

julia> collect(values(D))
2-element Vector{Int64}:
 2
 3
```

```
collect(element_type, collection)
```

コレクションまたはイテラブル内のすべてのアイテムの指定された要素タイプを持つ `Array` を返します。結果は `collection` と同じ形状と次元数を持ちます。

# 例

```jldoctest
julia> collect(Float64, 1:2:5)
3-element Vector{Float64}:
 1.0
 3.0
 5.0
```

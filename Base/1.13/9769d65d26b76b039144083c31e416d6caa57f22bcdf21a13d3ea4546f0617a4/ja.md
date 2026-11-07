```julia
collect(element_type, collection)
```

コレクションまたはイテラブル内のすべての要素を、指定した要素型の `Array` に変換して返します。結果の形状と次元数は `collection` と同じです。

# Examples

```jldoctest
julia> collect(Float64, 1:2:5)
3-element Vector{Float64}:
 1.0
 3.0
 5.0
```

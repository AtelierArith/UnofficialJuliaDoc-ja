```julia
partition(collection, n)
```

コレクションを `n` 要素ずつ反復処理します。

# 例

```jldoctest
julia> collect(Iterators.partition([1,2,3,4,5], 2))
3-element Vector{SubArray{Int64, 1, Vector{Int64}, Tuple{UnitRange{Int64}}, true}}:
 [1, 2]
 [3, 4]
 [5]
```

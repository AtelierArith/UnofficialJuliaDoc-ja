```julia
searchsortedlast(v, x; by=identity, lt=isless, rev=false)
```

`v` の値のうち、`x` より後に並ばない最後の値のインデックスを返します。`v` のすべての値が `x` より後に並ぶ場合は、`firstindex(v) - 1` を返します。

ベクトル `v` は、キーワードで定義された順序に従ってソートされている必要があります。返されたインデックスの直後に `insert!`ing `x` を挿入すると、ソート順が保たれます。キーワードの意味と使い方については、[`sort!`](@ref) を参照してください。`by` 関数は、検索対象の値 `x` と、`v` 内の値の両方に適用されることに注意してください。

インデックスは通常、二分探索で求められますが、一部の入力には最適化された実装が用意されています。

# Examples

```jldoctest
julia> searchsortedlast([1, 2, 4, 5, 5, 7], 4) # single match
3

julia> searchsortedlast([1, 2, 4, 5, 5, 7], 5) # multiple matches
5

julia> searchsortedlast([1, 2, 4, 5, 5, 7], 3) # no match, insert in the middle
2

julia> searchsortedlast([1, 2, 4, 5, 5, 7], 9) # no match, insert at end
6

julia> searchsortedlast([1, 2, 4, 5, 5, 7], 0) # no match, insert at start
0

julia> searchsortedlast([1=>"one", 2=>"two", 4=>"four"], 3=>"three", by=first) # compare the keys of the pairs
2
```

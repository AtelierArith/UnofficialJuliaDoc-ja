```julia
searchsortedfirst(v, x; by=identity, lt=isless, rev=false)
```

`v`の中で、`x`より前に並ばない最初の値のインデックスを返します。`v`のすべての値が`x`より前に並ぶ場合は、`lastindex(v) + 1`を返します。

ベクトル`v`は、キーワードで定義された順序に従ってソートされている必要があります。返されたインデックスに`x`を`insert!`すると、ソート順が保たれます。キーワードの意味と使い方については、[`sort!`](@ref)を参照してください。検索対象の値`x`だけでなく、`v`内の値にも`by`関数が適用されることに注意してください。

インデックスは通常、二分探索で求められますが、一部の入力には最適化された実装が用意されています。

関連項目: [`searchsortedlast`](@ref)、[`searchsorted`](@ref)、[`findfirst`](@ref)。

# Examples

```jldoctest
julia> searchsortedfirst([1, 2, 4, 5, 5, 7], 4) # single match
3

julia> searchsortedfirst([1, 2, 4, 5, 5, 7], 5) # multiple matches
4

julia> searchsortedfirst([1, 2, 4, 5, 5, 7], 3) # no match, insert in the middle
3

julia> searchsortedfirst([1, 2, 4, 5, 5, 7], 9) # no match, insert at end
7

julia> searchsortedfirst([1, 2, 4, 5, 5, 7], 0) # no match, insert at start
1

julia> searchsortedfirst([1=>"one", 2=>"two", 4=>"four"], 3=>"three", by=first) # compare the keys of the pairs
3
```

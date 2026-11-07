```julia
searchsorted(v, x; by=identity, lt=isless, rev=false)
```

`v` 内で `x` と等価な値がある場合は、そのインデックス範囲を返します。`v` に `x` と等価な値がない場合は、挿入位置を示す空の範囲を返します。ベクトル `v` は、キーワードで定義される順序に従ってソートされている必要があります。キーワードの意味と等価性の定義については、[`sort!`](@ref) を参照してください。`by` 関数は、検索対象の値 `x` と `v` 内の値の両方に適用されることに注意してください。

通常は二分探索で範囲を見つけますが、一部の入力には最適化された実装が用意されています。

関連項目: [`searchsortedfirst`](@ref)、[`sort!`](@ref)、[`insorted`](@ref)、[`findall`](@ref)。

# Examples

```jldoctest
julia> searchsorted([1, 2, 4, 5, 5, 7], 4) # single match
3:3

julia> searchsorted([1, 2, 4, 5, 5, 7], 5) # multiple matches
4:5

julia> searchsorted([1, 2, 4, 5, 5, 7], 3) # no match, insert in the middle
3:2 (empty range)

julia> searchsorted([1, 2, 4, 5, 5, 7], 9) # no match, insert at end
7:6 (empty range)

julia> searchsorted([1, 2, 4, 5, 5, 7], 0) # no match, insert at start
1:0 (empty range)

julia> searchsorted([1=>"one", 2=>"two", 2=>"two", 4=>"four"], 2=>"two", by=first) # compare the keys of the pairs
2:3
```

```julia
insorted(x, v; by=identity, lt=isless, rev=false)::Bool
```

ベクトル `v` に、`x` と等価な値が含まれているかどうかを判定します。ベクトル `v` は、キーワードで定義された順序に従ってソートされている必要があります。キーワードの意味と等価性の定義については、[`sort!`](@ref) を参照してください。検索対象の値 `x` にも、`v` 内の値と同様に、`by` 関数が適用されることに注意してください。

通常は二分探索で判定しますが、一部の入力には最適化された実装が用意されています。

[`in`](@ref) も参照してください。

# Examples

```jldoctest
julia> insorted(4, [1, 2, 4, 5, 5, 7]) # single match
true

julia> insorted(5, [1, 2, 4, 5, 5, 7]) # multiple matches
true

julia> insorted(3, [1, 2, 4, 5, 5, 7]) # no match
false

julia> insorted(9, [1, 2, 4, 5, 5, 7]) # no match
false

julia> insorted(0, [1, 2, 4, 5, 5, 7]) # no match
false

julia> insorted(2=>"TWO", [1=>"one", 2=>"two", 4=>"four"], by=first) # compare the keys of the pairs
true
```

!!! compat "Julia 1.6"
    `insorted` は Julia 1.6 で追加されました。


```julia
searchsortedfirst(v, x; by=identity, lt=isless, rev=false)
```

`v`の中で`x`よりも前に順序付けられていない最初の値のインデックスを返します。もし`v`のすべての値が`x`の前に順序付けられている場合は、`lastindex(v) + 1`を返します。

ベクトル`v`は、キーワードによって定義された順序に従ってソートされている必要があります。返されたインデックスに`x`を`insert!`すると、ソートされた順序が維持されます。キーワードの意味と使用法については[`sort!`](@ref)を参照してください。`by`関数は、検索される値`x`と`v`の値の両方に適用されることに注意してください。

インデックスは一般的に二分探索を使用して見つけられますが、一部の入力に対しては最適化された実装があります。

他にも: [`searchsortedlast`](@ref), [`searchsorted`](@ref), [`findfirst`](@ref).

# 例

```jldoctest
julia> searchsortedfirst([1, 2, 4, 5, 5, 7], 4) # 単一の一致
3

julia> searchsortedfirst([1, 2, 4, 5, 5, 7], 5) # 複数の一致
4

julia> searchsortedfirst([1, 2, 4, 5, 5, 7], 3) # 一致なし、中央に挿入
3

julia> searchsortedfirst([1, 2, 4, 5, 5, 7], 9) # 一致なし、末尾に挿入
7

julia> searchsortedfirst([1, 2, 4, 5, 5, 7], 0) # 一致なし、先頭に挿入
1

julia> searchsortedfirst([1=>"one", 2=>"two", 4=>"four"], 3=>"three", by=first) # ペアのキーを比較
3
```

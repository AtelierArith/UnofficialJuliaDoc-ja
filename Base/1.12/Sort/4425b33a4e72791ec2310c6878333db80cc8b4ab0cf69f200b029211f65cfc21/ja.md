```julia
searchsorted(v, x; by=identity, lt=isless, rev=false)
```

`v`内で`x`と等価な値のインデックスの範囲を返します。`v`に`x`と等価な値が含まれていない場合は、挿入ポイントに位置する空の範囲を返します。ベクトル`v`は、キーワードで定義された順序に従ってソートされている必要があります。キーワードの意味と等価性の定義については、[`sort!`](@ref)を参照してください。`by`関数は、検索される値`x`と`v`内の値の両方に適用されることに注意してください。

範囲は一般的に二分探索を使用して見つけられますが、一部の入力に対しては最適化された実装があります。

関連項目: [`searchsortedfirst`](@ref), [`sort!`](@ref), [`insorted`](@ref), [`findall`](@ref).

# 例

```jldoctest
julia> searchsorted([1, 2, 4, 5, 5, 7], 4) # 単一の一致
3:3

julia> searchsorted([1, 2, 4, 5, 5, 7], 5) # 複数の一致
4:5

julia> searchsorted([1, 2, 4, 5, 5, 7], 3) # 一致なし、中間に挿入
3:2

julia> searchsorted([1, 2, 4, 5, 5, 7], 9) # 一致なし、末尾に挿入
7:6

julia> searchsorted([1, 2, 4, 5, 5, 7], 0) # 一致なし、先頭に挿入
1:0

julia> searchsorted([1=>"one", 2=>"two", 2=>"two", 4=>"four"], 2=>"two", by=first) # ペアのキーを比較
2:3
```

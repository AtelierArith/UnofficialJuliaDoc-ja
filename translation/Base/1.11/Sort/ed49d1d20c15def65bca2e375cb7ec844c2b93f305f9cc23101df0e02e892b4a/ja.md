```
insorted(x, v; by=identity, lt=isless, rev=false) -> Bool
```

ベクトル `v` に `x` と等価な値が含まれているかどうかを判断します。ベクトル `v` はキーワードによって定義された順序に従ってソートされている必要があります。キーワードの意味や等価性の定義については [`sort!`](@ref) を参照してください。`by` 関数は、検索される値 `x` と `v` の値の両方に適用されます。

チェックは一般的に二分探索を使用して行われますが、一部の入力に対しては最適化された実装があります。

さらに [`in`](@ref) も参照してください。

# 例

```jldoctest
julia> insorted(4, [1, 2, 4, 5, 5, 7]) # 単一の一致
true

julia> insorted(5, [1, 2, 4, 5, 5, 7]) # 複数の一致
true

julia> insorted(3, [1, 2, 4, 5, 5, 7]) # 一致なし
false

julia> insorted(9, [1, 2, 4, 5, 5, 7]) # 一致なし
false

julia> insorted(0, [1, 2, 4, 5, 5, 7]) # 一致なし
false

julia> insorted(2=>"TWO", [1=>"one", 2=>"two", 4=>"four"], by=first) # ペアのキーを比較
true
```

!!! compat "Julia 1.6"
    `insorted` は Julia 1.6 で追加されました。


```

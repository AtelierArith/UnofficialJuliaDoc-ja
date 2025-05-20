```
checkbounds(Bool, A, I...)
```

指定されたインデックス `I` が与えられた配列 `A` の範囲内にある場合は `true` を返します。`AbstractArray` のサブタイプは、カスタムの範囲チェック動作を提供する必要がある場合、このメソッドを特化すべきですが、多くの場合、`A` のインデックスと [`checkindex`](@ref) に依存することができます。

関連情報として [`checkindex`](@ref) も参照してください。

# 例

```jldoctest
julia> A = rand(3, 3);

julia> checkbounds(Bool, A, 2)
true

julia> checkbounds(Bool, A, 3, 4)
false

julia> checkbounds(Bool, A, 1:3)
true

julia> checkbounds(Bool, A, 1:3, 2:4)
false
```

```julia
checkindex(Bool, inds::AbstractUnitRange, index)
```

与えられた `index` が `inds` の範囲内にある場合は `true` を返します。すべての配列のインデックスとして動作したいカスタム型は、このメソッドを拡張して特化した境界チェックの実装を提供できます。

[`checkbounds`](@ref) も参照してください。

# 例

```jldoctest
julia> checkindex(Bool, 1:20, 8)
true

julia> checkindex(Bool, 1:20, 21)
false
```

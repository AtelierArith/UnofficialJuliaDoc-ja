```julia
checkindex(Bool, inds::AbstractUnitRange, index)
```

指定された`index`が`inds`の範囲内にある場合は、`true`を返します。すべての配列でインデックスとして機能させたいカスタム型は、このメソッドを拡張することで、専用の境界チェック処理を実装できます。

[`checkbounds`](@ref)を参照してください。

# Examples

```jldoctest
julia> checkindex(Bool, 1:20, 8)
true

julia> checkindex(Bool, 1:20, 21)
false
```

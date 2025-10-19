```julia
isimmutable(v) -> Bool
```

!!! warning
    `isimmutable(v)` は将来のリリースで `!ismutable(v)` に置き換えられるため、代わりに `!ismutable(v)` を使用することを検討してください。 (Julia 1.5以降)


値 `v` が不変である場合にのみ `true` を返します。 不変性についての議論は [Mutable Composite Types](@ref) を参照してください。この関数は値に対して動作するため、型を与えると `DataType` の値が可変であると返します。

# 例

```jldoctest
julia> isimmutable(1)
true

julia> isimmutable([1,2])
false
```

```julia
isimmutable(v) -> Bool
```

!!! warning
    `isimmutable(v)` は将来のリリースで `!ismutable(v)` に置き換えられるため、代わりに `!ismutable(v)` を使用することを検討してください。（Julia 1.5 以降）


値 `v` が不変の場合に限り、`true` を返します。不変性については [Mutable Composite Types](@ref) を参照してください。この関数は値を対象とするため、型を渡すと、`DataType` の値は可変であると判定されます。

# Examples

```jldoctest
julia> isimmutable(1)
true

julia> isimmutable([1,2])
false
```

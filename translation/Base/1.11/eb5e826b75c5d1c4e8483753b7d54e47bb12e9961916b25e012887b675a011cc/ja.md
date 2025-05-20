```
issubset(a, b) -> Bool
⊆(a, b) -> Bool
⊇(b, a) -> Bool
```

`a`のすべての要素が`b`にも含まれているかどうかを判断します。 [`in`](@ref)を使用してください。

他に[`⊊`](@ref)、[`⊈`](@ref)、[`∩`](@ref intersect)、[`∪`](@ref union)、[`contains`](@ref)も参照してください。

# 例

```jldoctest
julia> issubset([1, 2], [1, 2, 3])
true

julia> [1, 2, 3] ⊆ [1, 2]
false

julia> [1, 2, 3] ⊇ [1, 2]
true
```

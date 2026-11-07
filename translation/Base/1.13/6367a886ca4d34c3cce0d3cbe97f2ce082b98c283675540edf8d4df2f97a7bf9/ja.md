```julia
issubset(a, b)::Bool
⊆(a, b)::Bool
⊇(b, a)::Bool
```

`a`のすべての要素が`b`にも含まれているかどうかを、[`in`](@ref)を使って判定します。

関連項目：[`⊊`](@ref)、[`⊈`](@ref)、[`∩`](@ref intersect)、[`∪`](@ref union)、[`contains`](@ref)。

# Examples

```jldoctest
julia> issubset([1, 2], [1, 2, 3])
true

julia> [1, 2, 3] ⊆ [1, 2]
false

julia> [1, 2, 3] ⊇ [1, 2]
true
```

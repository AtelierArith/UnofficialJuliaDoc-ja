```julia
issetequal(a, b)::Bool
```

`a`と`b`の要素が同じかどうかを判定します。可能な場合は、`a ⊆ b && b ⊆ a`と同等の処理をより効率的に行います。

関連項目：[`isdisjoint`](@ref)、[`union`](@ref)。

# Examples

```jldoctest
julia> issetequal([1, 2], [1, 2, 3])
false

julia> issetequal([1, 2], [2, 1])
true
```

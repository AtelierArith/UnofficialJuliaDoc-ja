```julia
issetequal(a, b)::Bool
```

`a`と`b`の要素が同じかどうかを判定します。`a ⊆ b && b ⊆ a`と同等ですが、可能な場合はこちらのほうが効率的です。

関連項目：[`isdisjoint`](@ref)、[`union`](@ref)。

# Examples

```jldoctest
julia> issetequal([1, 2], [1, 2, 3])
false

julia> issetequal([1, 2], [2, 1])
true
```

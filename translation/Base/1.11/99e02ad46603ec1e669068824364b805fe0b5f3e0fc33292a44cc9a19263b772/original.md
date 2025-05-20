```
issetequal(a, b) -> Bool
```

Determine whether `a` and `b` have the same elements. Equivalent to `a ⊆ b && b ⊆ a` but more efficient when possible.

See also: [`isdisjoint`](@ref), [`union`](@ref).

# Examples

```jldoctest
julia> issetequal([1, 2], [1, 2, 3])
false

julia> issetequal([1, 2], [2, 1])
true
```

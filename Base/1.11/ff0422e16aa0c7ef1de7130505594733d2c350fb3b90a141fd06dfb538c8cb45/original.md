```
isdisjoint(a, b) -> Bool
```

Determine whether the collections `a` and `b` are disjoint. Equivalent to `isempty(a ∩ b)` but more efficient when possible.

See also: [`intersect`](@ref), [`isempty`](@ref), [`issetequal`](@ref).

!!! compat "Julia 1.5"
    This function requires at least Julia 1.5.


# Examples

```jldoctest
julia> isdisjoint([1, 2], [2, 3, 4])
false

julia> isdisjoint([3, 1], [2, 4])
true
```

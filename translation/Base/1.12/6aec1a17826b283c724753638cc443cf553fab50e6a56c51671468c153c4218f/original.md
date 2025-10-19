```julia
issubset(a, b) -> Bool
⊆(a, b) -> Bool
⊇(b, a) -> Bool
```

Determine whether every element of `a` is also in `b`, using [`in`](@ref).

See also [`⊊`](@ref), [`⊈`](@ref), [`∩`](@ref intersect), [`∪`](@ref union), [`contains`](@ref).

# Examples

```jldoctest
julia> issubset([1, 2], [1, 2, 3])
true

julia> [1, 2, 3] ⊆ [1, 2]
false

julia> [1, 2, 3] ⊇ [1, 2]
true
```

```julia
tuple(xs...)
```

Construct a tuple of the given objects.

See also [`Tuple`](@ref), [`ntuple`](@ref), [`NamedTuple`](@ref).

# Examples

```jldoctest
julia> tuple(1, 'b', pi)
(1, 'b', π)

julia> ans === (1, 'b', π)
true

julia> Tuple(Real[1, 2, pi])  # takes a collection
(1, 2, π)
```

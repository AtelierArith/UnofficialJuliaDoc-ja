```julia
NTuple{N, T}
```

A compact way of representing the type for a tuple of length `N` where all elements are of type `T`.

# Examples

```jldoctest
julia> isa((1, 2, 3, 4, 5, 6), NTuple{6, Int})
true
```

See also [`ntuple`](@ref).

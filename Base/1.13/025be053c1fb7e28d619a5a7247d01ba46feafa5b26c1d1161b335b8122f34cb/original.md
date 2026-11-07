```julia
axes(A)
```

Return the tuple of valid indices for array `A`.

See also: [`size`](@ref), [`keys`](@ref), [`eachindex`](@ref).

# Examples

```jldoctest
julia> A = fill(1, (5,6,7));

julia> axes(A)
(Base.OneTo(5), Base.OneTo(6), Base.OneTo(7))
```

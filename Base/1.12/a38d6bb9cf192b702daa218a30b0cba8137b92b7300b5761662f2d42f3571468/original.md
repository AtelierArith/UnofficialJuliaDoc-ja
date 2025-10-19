```julia
vect(X...)
```

Create a [`Vector`](@ref) with element type computed from the `promote_typeof` of the argument, containing the argument list.

# Examples

```jldoctest
julia> a = Base.vect(UInt8(1), 2.5, 1//2)
3-element Vector{Float64}:
 1.0
 2.5
 0.5
```

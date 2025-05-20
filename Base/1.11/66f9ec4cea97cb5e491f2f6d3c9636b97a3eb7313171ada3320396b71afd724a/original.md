```
valtype(T::Type{<:AbstractArray})
valtype(A::AbstractArray)
```

Return the value type of an array. This is identical to [`eltype`](@ref) and is provided mainly for compatibility with the dictionary interface.

# Examples

```jldoctest
julia> valtype(["one", "two", "three"])
String
```

!!! compat "Julia 1.2"
    For arrays, this function requires at least Julia 1.2.


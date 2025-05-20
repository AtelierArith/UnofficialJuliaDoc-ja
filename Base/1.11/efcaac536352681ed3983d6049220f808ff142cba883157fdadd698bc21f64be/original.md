```
keytype(T::Type{<:AbstractArray})
keytype(A::AbstractArray)
```

Return the key type of an array. This is equal to the [`eltype`](@ref) of the result of `keys(...)`, and is provided mainly for compatibility with the dictionary interface.

# Examples

```jldoctest
julia> keytype([1, 2, 3]) == Int
true

julia> keytype([1 2; 3 4])
CartesianIndex{2}
```

!!! compat "Julia 1.2"
    For arrays, this function requires at least Julia 1.2.


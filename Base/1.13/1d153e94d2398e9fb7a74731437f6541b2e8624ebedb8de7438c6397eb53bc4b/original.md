```julia
elsize(type)
```

Compute the memory stride in bytes between consecutive elements of [`eltype`](@ref) stored inside the given `type`, if the array elements are stored densely with a uniform linear stride.

# Examples

```jldoctest
julia> Base.elsize(rand(Float32, 10))
4
```

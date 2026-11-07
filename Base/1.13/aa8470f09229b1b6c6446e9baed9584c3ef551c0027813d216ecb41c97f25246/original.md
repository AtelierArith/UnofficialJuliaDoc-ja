```julia
strides(A)
```

Return a tuple of the memory strides in each dimension.

See also: [`stride`](@ref).

# Examples

```jldoctest
julia> A = fill(1, (3,4,5));

julia> strides(A)
(1, 3, 12)
```

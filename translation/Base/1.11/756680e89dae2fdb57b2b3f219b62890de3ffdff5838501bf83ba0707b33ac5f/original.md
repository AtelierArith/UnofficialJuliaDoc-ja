```
ndims(A::AbstractArray) -> Integer
```

Return the number of dimensions of `A`.

See also: [`size`](@ref), [`axes`](@ref).

# Examples

```jldoctest
julia> A = fill(1, (3,4,5));

julia> ndims(A)
3
```

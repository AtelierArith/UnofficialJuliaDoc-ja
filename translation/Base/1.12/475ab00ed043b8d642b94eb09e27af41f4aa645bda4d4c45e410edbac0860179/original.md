```julia
stride(A, k::Integer)
```

Return the distance in memory (in number of elements) between adjacent elements in dimension `k`.

See also: [`strides`](@ref).

# Examples

```jldoctest
julia> A = fill(1, (3,4,5));

julia> stride(A,2)
3

julia> stride(A,3)
12
```

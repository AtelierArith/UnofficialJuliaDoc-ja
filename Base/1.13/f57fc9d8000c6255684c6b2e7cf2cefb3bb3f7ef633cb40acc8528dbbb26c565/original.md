```julia
prevind(A, i)
```

Return the index before `i` in `A`. The returned index is often equivalent to `i - 1` for an integer `i`. This function can be useful for generic code.

!!! warning
    The returned index might be out of bounds. Consider using [`checkbounds`](@ref).


See also: [`nextind`](@ref).

# Examples

```jldoctest
julia> x = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> prevind(x, 4) # valid result
3

julia> prevind(x, 1) # invalid result
0

julia> prevind(x, CartesianIndex(2, 2)) # valid result
CartesianIndex(1, 2)

julia> prevind(x, CartesianIndex(1, 1)) # invalid result
CartesianIndex(2, 0)
```

```
nextind(A, i)
```

Return the index after `i` in `A`. The returned index is often equivalent to `i + 1` for an integer `i`. This function can be useful for generic code.

!!! warning
    The returned index might be out of bounds. Consider using [`checkbounds`](@ref).


See also: [`prevind`](@ref).

# Examples

```jldoctest
julia> x = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> nextind(x, 1) # valid result
2

julia> nextind(x, 4) # invalid result
5

julia> nextind(x, CartesianIndex(1, 1)) # valid result
CartesianIndex(2, 1)

julia> nextind(x, CartesianIndex(2, 2)) # invalid result
CartesianIndex(1, 3)
```

```
symdiff(s, itrs...)
```

Construct the symmetric difference of elements in the passed in sets. When `s` is not an `AbstractSet`, the order is maintained.

See also [`symdiff!`](@ref), [`setdiff`](@ref), [`union`](@ref) and [`intersect`](@ref).

# Examples

```jldoctest
julia> symdiff([1,2,3], [3,4,5], [4,5,6])
3-element Vector{Int64}:
 1
 2
 6

julia> symdiff([1,2,1], [2, 1, 2])
Int64[]
```

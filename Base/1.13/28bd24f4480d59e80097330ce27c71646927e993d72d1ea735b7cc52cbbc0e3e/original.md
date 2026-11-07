```julia
setdiff(s, itrs...)
```

Construct the set of elements in `s` but not in any of the iterables in `itrs`. Maintain order with arrays. The result will have the same element type as `s`.

See also [`setdiff!`](@ref), [`union`](@ref) and [`intersect`](@ref).

# Examples

```jldoctest
julia> setdiff([1,2,3], [3,4,5])
2-element Vector{Int64}:
 1
 2

julia> setdiff([1,2,3], [1.0, 2.0])
1-element Vector{Int64}:
 3
```

```
setdiff(s, itrs...)
```

Construct the set of elements in `s` but not in any of the iterables in `itrs`. Maintain order with arrays.

See also [`setdiff!`](@ref), [`union`](@ref) and [`intersect`](@ref).

# Examples

```jldoctest
julia> setdiff([1,2,3], [3,4,5])
2-element Vector{Int64}:
 1
 2
```

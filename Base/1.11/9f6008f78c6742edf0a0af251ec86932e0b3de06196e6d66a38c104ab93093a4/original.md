```
deleteat!(a::Vector, i::Integer)
```

Remove the item at the given `i` and return the modified `a`. Subsequent items are shifted to fill the resulting gap.

See also: [`keepat!`](@ref), [`delete!`](@ref), [`popat!`](@ref), [`splice!`](@ref).

# Examples

```jldoctest
julia> deleteat!([6, 5, 4, 3, 2, 1], 2)
5-element Vector{Int64}:
 6
 4
 3
 2
 1
```

```julia
unique(itr)
```

Return an array containing only the unique elements of collection `itr`, as determined by [`isequal`](@ref) and [`hash`](@ref), in the order that the first of each set of equivalent elements originally appears. The element type of the input is preserved.

See also: [`unique!`](@ref), [`allunique`](@ref), [`allequal`](@ref).

# Examples

```jldoctest
julia> unique([1, 2, 6, 2])
3-element Vector{Int64}:
 1
 2
 6

julia> unique(Real[1, 1.0, 2])
2-element Vector{Real}:
 1
 2
```

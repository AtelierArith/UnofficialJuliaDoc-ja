```julia
keys(a::AbstractArray)
```

Return an efficient array describing all valid indices for `a` arranged in the shape of `a` itself.

The keys of 1-dimensional arrays (vectors) are integers, whereas all other N-dimensional arrays use [`CartesianIndex`](@ref) to describe their locations.  Often the special array types [`LinearIndices`](@ref) and [`CartesianIndices`](@ref) are used to efficiently represent these arrays of integers and `CartesianIndex`es, respectively.

Note that the `keys` of an array might not be the most efficient index type; for maximum performance use  [`eachindex`](@ref) instead.

# Examples

```jldoctest
julia> keys([4, 5, 6])
3-element LinearIndices{1, Tuple{Base.OneTo{Int64}}}:
 1
 2
 3

julia> keys([4 5; 6 7])
CartesianIndices((2, 2))
```

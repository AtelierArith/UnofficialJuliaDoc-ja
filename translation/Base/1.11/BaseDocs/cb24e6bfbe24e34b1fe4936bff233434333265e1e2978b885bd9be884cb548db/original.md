```
Array{T}(nothing, dims)
Array{T,N}(nothing, dims)
```

Construct an `N`-dimensional [`Array`](@ref) containing elements of type `T`, initialized with [`nothing`](@ref) entries. Element type `T` must be able to hold these values, i.e. `Nothing <: T`.

# Examples

```jldoctest
julia> Array{Union{Nothing, String}}(nothing, 2)
2-element Vector{Union{Nothing, String}}:
 nothing
 nothing

julia> Array{Union{Nothing, Int}}(nothing, 2, 3)
2×3 Matrix{Union{Nothing, Int64}}:
 nothing  nothing  nothing
 nothing  nothing  nothing
```

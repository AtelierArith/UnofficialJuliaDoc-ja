```julia
Array{T}(missing, dims)
Array{T,N}(missing, dims)
```

Construct an `N`-dimensional [`Array`](@ref) containing elements of type `T`, initialized with [`missing`](@ref) entries. Element type `T` must be able to hold these values, i.e. `Missing <: T`.

# Examples

```jldoctest
julia> Array{Union{Missing, String}}(missing, 2)
2-element Vector{Union{Missing, String}}:
 missing
 missing

julia> Array{Union{Missing, Int}}(missing, 2, 3)
2×3 Matrix{Union{Missing, Int64}}:
 missing  missing  missing
 missing  missing  missing
```

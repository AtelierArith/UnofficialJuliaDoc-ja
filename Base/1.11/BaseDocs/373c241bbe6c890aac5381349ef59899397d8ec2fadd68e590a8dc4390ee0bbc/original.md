```
Matrix{T}(nothing, m, n)
```

Construct a [`Matrix{T}`](@ref) of size `m`×`n`, initialized with [`nothing`](@ref) entries. Element type `T` must be able to hold these values, i.e. `Nothing <: T`.

# Examples

```jldoctest
julia> Matrix{Union{Nothing, String}}(nothing, 2, 3)
2×3 Matrix{Union{Nothing, String}}:
 nothing  nothing  nothing
 nothing  nothing  nothing
```

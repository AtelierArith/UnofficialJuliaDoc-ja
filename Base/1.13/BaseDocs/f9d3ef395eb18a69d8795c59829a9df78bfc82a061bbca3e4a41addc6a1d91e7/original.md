```julia
Vector{T}(missing, m)
```

Construct a [`Vector{T}`](@ref) of length `m`, initialized with [`missing`](@ref) entries. Element type `T` must be able to hold these values, i.e. `Missing <: T`.

# Examples

```jldoctest
julia> Vector{Union{Missing, String}}(missing, 2)
2-element Vector{Union{Missing, String}}:
 missing
 missing
```

```
Vector{T}(nothing, m)
```

Construct a [`Vector{T}`](@ref) of length `m`, initialized with [`nothing`](@ref) entries. Element type `T` must be able to hold these values, i.e. `Nothing <: T`.

# Examples

```jldoctest
julia> Vector{Union{Nothing, String}}(nothing, 2)
2-element Vector{Union{Nothing, String}}:
 nothing
 nothing
```

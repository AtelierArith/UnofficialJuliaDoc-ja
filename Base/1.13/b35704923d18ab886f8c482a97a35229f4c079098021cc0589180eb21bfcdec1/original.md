```julia
promote_typejoin(T, S)
```

Compute a type that contains both `T` and `S`, which could be either a parent of both types, or a `Union` if appropriate. Falls back to [`typejoin`](@ref).

See instead [`promote`](@ref), [`promote_type`](@ref).

# Examples

```jldoctest
julia> Base.promote_typejoin(Int, Float64)
Real

julia> Base.promote_type(Int, Float64)
Float64
```

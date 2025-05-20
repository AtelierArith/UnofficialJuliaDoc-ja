```
AbstractRange{T} <: AbstractVector{T}
```

Supertype for linear ranges with elements of type `T`. [`UnitRange`](@ref), [`LinRange`](@ref) and other types are subtypes of this.

All subtypes must define [`step`](@ref). Thus [`LogRange`](@ref Base.LogRange) is not a subtype of `AbstractRange`.

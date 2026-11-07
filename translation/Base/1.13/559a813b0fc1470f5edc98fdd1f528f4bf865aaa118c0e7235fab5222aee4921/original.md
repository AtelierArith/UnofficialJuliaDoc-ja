```julia
Base.iskindtype(T)
```

Determine whether `T` is a kind, that is, the type of a Julia type: a [`DataType`](@ref), [`Union`](@ref), [`UnionAll`](@ref), or [`Core.TypeofBottom`](@ref).

All kinds are [concrete](@ref isconcretetype) because types are Julia values.

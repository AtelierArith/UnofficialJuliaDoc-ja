```julia
Base.isconcretedispatch(T)
```

Returns true if `T` is a [concrete type](@ref isconcretetype) that could appear as an element of a [dispatch tuple](@ref isdispatchtuple).

See also: [`isdispatchtuple`](@ref).

# Examples

```jldoctest
julia> Base.isconcretedispatch(Int)
true

julia> Base.isconcretedispatch(Number)
false

julia> Base.isconcretedispatch(DataType)
false

julia> Base.isconcretedispatch(Type{Int})
false
```

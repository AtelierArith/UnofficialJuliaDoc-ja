```julia
isabstracttype(T)
```

Determine whether type `T` was declared as an abstract type (i.e. using the `abstract type` syntax). If `T` is not a type, then return `false`.

!!! note
    While abstract types are not [concrete](@ref isconcretetype) and vice versa, types can be neither concrete nor abstract (for example, `Vector` (a [`UnionAll`](@ref))).


See also: [`isconcretetype`](@ref).

# Examples

```jldoctest
julia> isabstracttype(AbstractArray)
true

julia> isabstracttype(Vector)
false
```

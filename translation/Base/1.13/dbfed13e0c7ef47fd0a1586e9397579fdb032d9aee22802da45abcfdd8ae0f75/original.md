```julia
isdispatchtuple(T)
```

Determine whether type `T` is a [`Tuple`](@ref) that could appear as a type signature in dispatch.  For this to be true, every element of the tuple type must be either:

  * [concrete](@ref isconcretetype) but not a [kind type](@ref Base.iskindtype)
  * a [`Type{U}`](@ref Type) with no free type variables in `U`

!!! note
    A dispatch tuple is relevant for method dispatch because it has no inhabited subtypes.

    For example, `Tuple{Int, DataType}` is concrete, but is not a dispatch tuple because `Tuple{Int, Type{Bool}}` is an inhabited subtype.

    `Tuple{Tuple{DataType}}` *is* a dispatch tuple because `Tuple{DataType}` is concrete and not a kind; the subtype `Tuple{Tuple{Type{Int}}}` is not inhabited.


If `T` is not a type, then return `false`.

# Examples

```jldoctest
julia> isdispatchtuple(Int)
false

julia> isdispatchtuple(Tuple{Int})
true

julia> isdispatchtuple(Tuple{Number})
false

julia> isdispatchtuple(Tuple{DataType})
false

julia> isdispatchtuple(Tuple{Type{Int}})
true

julia> isdispatchtuple(Tuple{Type})
false
```

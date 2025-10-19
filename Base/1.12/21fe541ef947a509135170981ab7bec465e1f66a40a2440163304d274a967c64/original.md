```julia
nonmissingtype(T::Type)
```

If `T` is a union of types containing `Missing`, return a new type with `Missing` removed.

# Examples

```jldoctest
julia> nonmissingtype(Union{Int64,Missing})
Int64

julia> nonmissingtype(Any)
Any
```

!!! compat "Julia 1.3"
    This function is exported as of Julia 1.3.


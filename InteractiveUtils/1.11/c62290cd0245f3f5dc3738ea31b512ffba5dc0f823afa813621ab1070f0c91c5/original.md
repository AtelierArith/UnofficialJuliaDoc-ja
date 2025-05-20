```
supertypes(T::Type)
```

Return a tuple `(T, ..., Any)` of `T` and all its supertypes, as determined by successive calls to the [`supertype`](@ref) function, listed in order of `<:` and terminated by `Any`.

See also [`subtypes`](@ref).

# Examples

```jldoctest
julia> supertypes(Int)
(Int64, Signed, Integer, Real, Number, Any)
```

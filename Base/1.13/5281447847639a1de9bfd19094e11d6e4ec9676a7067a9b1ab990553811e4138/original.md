```julia
Base.Chars = Union{AbstractChar,Tuple{Vararg{AbstractChar}},AbstractVector{<:AbstractChar},AbstractSet{<:AbstractChar}}
```

An alias type for either a single character or a tuple/vector/set of characters, used to describe arguments of several string-matching functions such as [`startswith`](@ref) and [`strip`](@ref).

!!! compat "Julia 1.11"
    Julia versions prior to 1.11 only included `Set`, not `AbstractSet`, in `Base.Chars` types.


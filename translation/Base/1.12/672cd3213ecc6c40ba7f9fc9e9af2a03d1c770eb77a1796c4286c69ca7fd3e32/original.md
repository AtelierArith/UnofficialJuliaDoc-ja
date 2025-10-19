```julia
startswith(io::IO, prefix::Union{AbstractString,Base.Chars})
```

Check if an `IO` object starts with a prefix, which can be either a string, a character, or a tuple/vector/set of characters.  See also [`peek`](@ref).

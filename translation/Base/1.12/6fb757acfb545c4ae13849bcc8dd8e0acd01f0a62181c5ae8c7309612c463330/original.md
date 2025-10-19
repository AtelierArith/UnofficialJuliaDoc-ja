```julia
iterate(s::AbstractString, i::Integer) -> Union{Tuple{<:AbstractChar, Int}, Nothing}
```

Return a tuple of the character in `s` at index `i` with the index of the start of the following character in `s`. This is the key method that allows strings to be iterated, yielding a sequences of characters. The `iterate` function, as part of the iteration protocol may assume that `i` is the start of a character in `s`.

See also [`getindex`](@ref), [`checkbounds`](@ref).

```julia
uppercasefirst(s::AbstractString) -> String
```

Return `s` with the first character converted to uppercase (technically "title case" for Unicode). See also [`titlecase`](@ref) to capitalize the first character of every word in `s`.

See also [`lowercasefirst`](@ref), [`uppercase`](@ref), [`lowercase`](@ref), [`titlecase`](@ref).

# Examples

```jldoctest
julia> uppercasefirst("python")
"Python"
```

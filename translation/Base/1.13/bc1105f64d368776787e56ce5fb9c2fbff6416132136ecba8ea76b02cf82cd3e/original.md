```julia
unindent(str::AbstractString, indent::Int; tabwidth=8)
```

Remove leading indentation from string.

See also `indent` from the [`MultilineStrings` package](https://github.com/invenia/MultilineStrings.jl).

# Examples

```jldoctest
julia> Base.unindent("   a\n   b", 2)
" a\n b"

julia> Base.unindent("\ta\n\tb", 2, tabwidth=8)
"      a\n      b"
```

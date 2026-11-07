```julia
extendedterminfo(data::IO; NumInt::Union{Type{Int16}, Type{Int32}})
```

Read an extended terminfo section from `data`, with `NumInt` as the numbers type.

This will accept any terminfo content that conforms with `term(5)`.

See also: `read(::IO, ::Type{TermInfoRaw})`

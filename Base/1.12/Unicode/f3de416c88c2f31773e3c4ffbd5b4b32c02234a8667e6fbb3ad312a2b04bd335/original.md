```julia
ispunct(c::AbstractChar) -> Bool
```

Tests whether a character belongs to the Unicode general category Punctuation, i.e. a character whose category code begins with 'P'.

!!! note
    This behavior is different from the `ispunct` function in C.


# Examples

```jldoctest
julia> ispunct('α')
false

julia> ispunct('=')
false

julia> ispunct('/')
true

julia> ispunct(';')
true
```

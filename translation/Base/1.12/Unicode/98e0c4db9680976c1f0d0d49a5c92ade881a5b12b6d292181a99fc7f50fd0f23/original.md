```julia
isprint(c::AbstractChar) -> Bool
```

Tests whether a character is printable, including spaces, but not a control character.

# Examples

```jldoctest
julia> isprint('\x01')
false

julia> isprint('A')
true
```

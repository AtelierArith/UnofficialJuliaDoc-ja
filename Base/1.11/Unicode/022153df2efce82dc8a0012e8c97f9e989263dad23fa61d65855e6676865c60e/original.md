```
iscntrl(c::AbstractChar) -> Bool
```

Tests whether a character is a control character. Control characters are the non-printing characters of the Latin-1 subset of Unicode.

# Examples

```jldoctest
julia> iscntrl('\x01')
true

julia> iscntrl('a')
false
```

```
isxdigit(c::AbstractChar) -> Bool
```

Test whether a character is a valid hexadecimal digit. Note that this does not include `x` (as in the standard `0x` prefix).

# Examples

```jldoctest
julia> isxdigit('a')
true

julia> isxdigit('x')
false
```

```julia
Unicode.isassigned(c) -> Bool
```

Return `true` if the given char or integer is an assigned Unicode code point.

# Examples

```jldoctest
julia> Unicode.isassigned(101)
true

julia> Unicode.isassigned('\x01')
true
```

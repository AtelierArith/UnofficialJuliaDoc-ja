```julia
isdigit(c::AbstractChar) -> Bool
```

Tests whether a character is an ASCII decimal digit (`0`-`9`).

See also: [`isletter`](@ref).

# Examples

```jldoctest
julia> isdigit('❤')
false

julia> isdigit('9')
true

julia> isdigit('α')
false
```

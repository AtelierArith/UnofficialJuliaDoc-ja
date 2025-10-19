```julia
isletter(c::AbstractChar) -> Bool
```

Test whether a character is a letter. A character is classified as a letter if it belongs to the Unicode general category Letter, i.e. a character whose category code begins with 'L'.

See also: [`isdigit`](@ref).

# Examples

```jldoctest
julia> isletter('❤')
false

julia> isletter('α')
true

julia> isletter('9')
false
```

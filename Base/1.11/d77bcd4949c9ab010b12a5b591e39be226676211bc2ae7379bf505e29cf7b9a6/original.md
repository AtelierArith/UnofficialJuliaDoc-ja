```
repeat(s::AbstractString, r::Integer)
```

Repeat a string `r` times. This can be written as `s^r`.

See also [`^`](@ref :^(::Union{AbstractString, AbstractChar}, ::Integer)).

# Examples

```jldoctest
julia> repeat("ha", 3)
"hahaha"
```

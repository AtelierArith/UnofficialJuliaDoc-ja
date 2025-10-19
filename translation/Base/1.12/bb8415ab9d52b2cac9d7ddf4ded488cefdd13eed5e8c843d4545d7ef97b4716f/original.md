```julia
^(s::Union{AbstractString,AbstractChar}, n::Integer) -> AbstractString
```

Repeat a string or character `n` times. This can also be written as `repeat(s, n)`.

See also [`repeat`](@ref).

# Examples

```jldoctest
julia> "Test "^3
"Test Test Test "
```

```julia
uppercase(c::AbstractChar)
```

Convert `c` to uppercase.

See also [`lowercase`](@ref), [`titlecase`](@ref).

# Examples

```jldoctest
julia> uppercase('a')
'A': ASCII/Unicode U+0041 (category Lu: Letter, uppercase)

julia> uppercase('ê')
'Ê': Unicode U+00CA (category Lu: Letter, uppercase)
```

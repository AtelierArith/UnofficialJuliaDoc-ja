```
titlecase(c::AbstractChar)
```

Convert `c` to titlecase. This may differ from uppercase for digraphs, compare the example below.

See also [`uppercase`](@ref), [`lowercase`](@ref).

# Examples

```jldoctest
julia> titlecase('a')
'A': ASCII/Unicode U+0041 (category Lu: Letter, uppercase)

julia> titlecase('ǆ')
'ǅ': Unicode U+01C5 (category Lt: Letter, titlecase)

julia> uppercase('ǆ')
'Ǆ': Unicode U+01C4 (category Lu: Letter, uppercase)
```

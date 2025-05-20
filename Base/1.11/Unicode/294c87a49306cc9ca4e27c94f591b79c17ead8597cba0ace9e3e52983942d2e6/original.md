```
lowercase(c::AbstractChar)
```

Convert `c` to lowercase.

See also [`uppercase`](@ref), [`titlecase`](@ref).

# Examples

```jldoctest
julia> lowercase('A')
'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)

julia> lowercase('Ö')
'ö': Unicode U+00F6 (category Ll: Letter, lowercase)
```

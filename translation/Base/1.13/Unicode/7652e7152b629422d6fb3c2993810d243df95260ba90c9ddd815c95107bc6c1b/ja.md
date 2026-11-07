```julia
uppercase(c::AbstractChar)
```

`c`を大文字に変換します。

[`lowercase`](@ref)、[`titlecase`](@ref)も参照してください。

# Examples

```jldoctest
julia> uppercase('a')
'A': ASCII/Unicode U+0041 (category Lu: Letter, uppercase)

julia> uppercase('ê')
'Ê': Unicode U+00CA (category Lu: Letter, uppercase)
```

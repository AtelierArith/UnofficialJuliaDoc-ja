```julia
lowercase(c::AbstractChar)
```

`c`を小文字に変換します。

[`uppercase`](@ref)、[`titlecase`](@ref)も参照してください。

# Examples

```jldoctest
julia> lowercase('A')
'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)

julia> lowercase('Ö')
'ö': Unicode U+00F6 (category Ll: Letter, lowercase)
```

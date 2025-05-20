```
uppercase(c::AbstractChar)
```

`c`を大文字に変換します。

関連項目としては[`lowercase`](@ref)、[`titlecase`](@ref)があります。

# 例

```jldoctest
julia> uppercase('a')
'A': ASCII/Unicode U+0041 (category Lu: Letter, uppercase)

julia> uppercase('ê')
'Ê': Unicode U+00CA (category Lu: Letter, uppercase)
```

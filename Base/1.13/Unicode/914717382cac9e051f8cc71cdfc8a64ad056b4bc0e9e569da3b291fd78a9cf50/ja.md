```julia
titlecase(c::AbstractChar)
```

`c` をタイトルケースに変換します。二重音字の場合は大文字とは異なることがあります。以下の例を参照してください。

関連項目: [`uppercase`](@ref)、[`lowercase`](@ref)。

# Examples

```jldoctest
julia> titlecase('a')
'A': ASCII/Unicode U+0041 (category Lu: Letter, uppercase)

julia> titlecase('ǆ')
'ǅ': Unicode U+01C5 (category Lt: Letter, titlecase)

julia> uppercase('ǆ')
'Ǆ': Unicode U+01C4 (category Lu: Letter, uppercase)
```

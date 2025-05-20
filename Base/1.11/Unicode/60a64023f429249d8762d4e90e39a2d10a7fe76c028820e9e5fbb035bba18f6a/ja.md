```
titlecase(c::AbstractChar)
```

`c`をタイトルケースに変換します。これは二重音字に対して大文字とは異なる場合があります。以下の例を比較してください。

関連情報としては [`uppercase`](@ref)、[`lowercase`](@ref) があります。

# 例

```jldoctest
julia> titlecase('a')
'A': ASCII/Unicode U+0041 (category Lu: Letter, uppercase)

julia> titlecase('ǆ')
'ǅ': Unicode U+01C5 (category Lt: Letter, titlecase)

julia> uppercase('ǆ')
'Ǆ': Unicode U+01C4 (category Lu: Letter, uppercase)
```

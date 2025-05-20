```
uppercasefirst(s::AbstractString) -> String
```

`s`の最初の文字を大文字に変換したものを返します（技術的にはUnicodeの「タイトルケース」です）。`s`のすべての単語の最初の文字を大文字にするには、[`titlecase`](@ref)も参照してください。

また、[`lowercasefirst`](@ref)、[`uppercase`](@ref)、[`lowercase`](@ref)、[`titlecase`](@ref)も参照してください。

# 例

```jldoctest
julia> uppercasefirst("python")
"Python"
```

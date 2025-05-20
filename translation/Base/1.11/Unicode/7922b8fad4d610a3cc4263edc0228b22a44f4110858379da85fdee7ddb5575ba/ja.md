```
titlecase(s::AbstractString; [wordsep::Function], strict::Bool=true) -> String
```

`s`の各単語の最初の文字を大文字にします。`strict`がtrueの場合、他のすべての文字は小文字に変換されますが、そうでない場合は変更されません。デフォルトでは、新しいグラフェムを開始するすべての非文字は単語の区切りと見なされます。どの文字を単語の区切りと見なすかを決定するために、`wordsep`キーワードとして述語を渡すことができます。`s`の最初の文字だけを大文字にするには、[`uppercasefirst`](@ref)も参照してください。

[`uppercase`](@ref)、[`lowercase`](@ref)、[`uppercasefirst`](@ref)も参照してください。

# 例

```jldoctest
julia> titlecase("the JULIA programming language")
"The Julia Programming Language"

julia> titlecase("ISS - international space station", strict=false)
"ISS - International Space Station"

julia> titlecase("a-a b-b", wordsep = c->c==' ')
"A-a B-b"
```

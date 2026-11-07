```julia
titlecase(s::AbstractString; [wordsep::Function], strict::Bool=true)::String
```

`s`の各単語の先頭文字を大文字にします。`strict`がtrueの場合は、それ以外の文字をすべて小文字に変換します。falseの場合は、元のままにします。デフォルトでは、新しい書記素の先頭にある文字以外のすべての文字を単語の区切りとみなします。どの文字を単語の区切りとみなすかは、`wordsep`キーワードに述語を渡して指定できます。[`uppercasefirst`](@ref)も参照してください。こちらは`s`の先頭文字だけを大文字にします。

[`uppercase`](@ref)、[`lowercase`](@ref)、[`uppercasefirst`](@ref)も参照してください。

# Examples

```jldoctest
julia> titlecase("the JULIA programming language")
"The Julia Programming Language"

julia> titlecase("ISS - international space station", strict=false)
"ISS - International Space Station"

julia> titlecase("a-a b-b", wordsep = c->c==' ')
"A-a B-b"
```

```julia
titlecase(s::AbstractString; [wordsep::Function], strict::Bool=true)::String
```

`s` の各単語の先頭文字を大文字にします。`strict` が true の場合は、それ以外の文字をすべて小文字に変換し、そうでない場合は変更しません。デフォルトでは、新しい書記素の先頭にある文字以外のすべての文字が単語の区切りとみなされます。単語の区切りとみなす文字を指定するには、述語を `wordsep` キーワード引数に渡します。`s` の先頭文字だけを大文字にするには、[`uppercasefirst`](@ref) も参照してください。

[`uppercase`](@ref)、[`lowercase`](@ref)、[`uppercasefirst`](@ref) も参照してください。

# Examples

```jldoctest
julia> titlecase("the JULIA programming language")
"The Julia Programming Language"

julia> titlecase("ISS - international space station", strict=false)
"ISS - International Space Station"

julia> titlecase("a-a b-b", wordsep = c->c==' ')
"A-a B-b"
```

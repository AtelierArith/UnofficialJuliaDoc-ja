```
lowercase(s::AbstractString)
```

すべての文字を小文字に変換した`s`を返します。

関連情報としては、[`uppercase`](@ref)、[`titlecase`](@ref)、[`lowercasefirst`](@ref)があります。

# 例

```jldoctest
julia> lowercase("STRINGS AND THINGS")
"strings and things"
```

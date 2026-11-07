```julia
lowercase(s::AbstractString)
```

すべての文字を小文字に変換した `s` を返します。

こちらも参照してください：[`uppercase`](@ref)、[`titlecase`](@ref)、[`lowercasefirst`](@ref)。

# Examples

```jldoctest
julia> lowercase("STRINGS AND THINGS")
"strings and things"
```

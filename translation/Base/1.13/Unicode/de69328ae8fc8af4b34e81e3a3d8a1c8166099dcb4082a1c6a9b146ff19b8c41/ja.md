```julia
lowercase(s::AbstractString)
```

すべての文字を小文字に変換した`s`を返します。

[`uppercase`](@ref)、[`titlecase`](@ref)、[`lowercasefirst`](@ref)も参照してください。

# Examples

```jldoctest
julia> lowercase("STRINGS AND THINGS")
"strings and things"
```

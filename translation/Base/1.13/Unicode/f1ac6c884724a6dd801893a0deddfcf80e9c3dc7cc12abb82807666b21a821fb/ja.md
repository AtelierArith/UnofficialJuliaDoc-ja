```julia
lowercasefirst(s::AbstractString)
```

先頭の文字を小文字に変換した `s` を返します。

関連項目: [`uppercasefirst`](@ref)、[`uppercase`](@ref)、[`lowercase`](@ref)、[`titlecase`](@ref)。

# Examples

```jldoctest
julia> lowercasefirst("Julia")
"julia"
```

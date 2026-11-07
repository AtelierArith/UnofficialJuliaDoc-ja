```julia
lowercasefirst(s::AbstractString)
```

先頭の文字を小文字に変換した`s`を返します。

[`uppercasefirst`](@ref)、[`uppercase`](@ref)、[`lowercase`](@ref)、[`titlecase`](@ref)も参照してください。

# Examples

```jldoctest
julia> lowercasefirst("Julia")
"julia"
```

```julia
uppercase(s::AbstractString)
```

すべての文字を大文字に変換した`s`を返します。

[`lowercase`](@ref)、[`titlecase`](@ref)、[`uppercasefirst`](@ref)も参照してください。

# Examples

```jldoctest
julia> uppercase("Julia")
"JULIA"
```

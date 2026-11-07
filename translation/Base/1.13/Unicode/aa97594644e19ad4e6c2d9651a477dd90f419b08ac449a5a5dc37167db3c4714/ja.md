```julia
uppercasefirst(s::AbstractString)::String
```

最初の文字を大文字（Unicode の「タイトルケース」）に変換した `s` を返します。[`titlecase`](@ref) も参照してください。こちらは `s` の各単語の最初の文字を大文字にします。

[`lowercasefirst`](@ref)、[`uppercase`](@ref)、[`lowercase`](@ref)、[`titlecase`](@ref) も参照してください。

# Examples

```jldoctest
julia> uppercasefirst("python")
"Python"
```

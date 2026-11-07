```julia
@md_str -> MD
```

与えられた文字列をMarkdownテキストとして解析し、対応する[`MD`](@ref)オブジェクトを返します。

[`Markdown.parse`](@ref Markdown.parse(::AbstractString))も参照してください。

# Examples

```jldoctest
julia> s = md"# Hello, world!"
  Hello, world!
  ≡≡≡≡≡≡≡≡≡≡≡≡≡

julia> typeof(s)
Markdown.MD

```

```julia
@md_str -> MD
```

与えられた文字列をMarkdownテキストとして解析し、対応する [`MD`](@ref) オブジェクトを返します。

関連情報として [`Markdown.parse`](@ref Markdown.parse(::AbstractString)) も参照してください。

# 例

```jldoctest
julia> s = md"# Hello, world!"
  Hello, world!
  ≡≡≡≡≡≡≡≡≡≡≡≡≡

julia> typeof(s)
Markdown.MD

```

```
@md_str -> MD
```

与えられた文字列をMarkdownテキストとして解析し、対応する[`MD`](@ref)オブジェクトを返します。

# 例

```jldoctest
julia> s = md"# こんにちは、世界！"
  こんにちは、世界！
  ≡≡≡≡≡≡≡≡≡≡≡≡≡

julia> typeof(s)
Markdown.MD

```

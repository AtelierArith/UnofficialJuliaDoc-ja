```
convert(::Type{Markdown.MD}, node::Node) -> Markdown.MD
```

Markdown文書のMarkdownAST表現を`Markdown`標準ライブラリの表現に変換します。

ルートノード`node`は[`Document`](@ref)要素である必要があります。

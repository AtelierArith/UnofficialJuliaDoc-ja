```julia
convert(::Type{Markdown.MD}, node::Node) -> Markdown.MD
```

Converts a MarkdownAST representation of a Markdown document into the `Markdown` standard library representation.

Note that the root node `node` must a [`Document`](@ref) element.

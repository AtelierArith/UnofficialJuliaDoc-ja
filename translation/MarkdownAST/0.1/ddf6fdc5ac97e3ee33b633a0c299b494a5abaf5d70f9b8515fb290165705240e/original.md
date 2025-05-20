```
convert(::Type{Node}, md::Markdown.MD) -> Node
convert(::Type{Node{M}}, md::Markdown.MD, meta=M) where M -> Node{M}
```

Converts a standard library Markdown AST into MarkdownAST representation.

Note that it is not possible to convert subtrees, as only `MD` objects can be converted. The result will be a tree with [`Document`](@ref) as the root element.

When the type argument passed is `Node`, the resulting tree will be constructed of objects of the default node type `Node{Nothing}`. However, it is also possible to convert into MarkdownAST trees that have custom metadata field of type `M`, in which case the `M` type must have a zero-argument constructor available, which will be called whenever a new `Node` object gets constructed.

It is also possible to use a custom function to construct the `.meta` objects via the `meta argument, which must be a callable object with a zero-argument method, and that then gets called every time a new node is constructed.

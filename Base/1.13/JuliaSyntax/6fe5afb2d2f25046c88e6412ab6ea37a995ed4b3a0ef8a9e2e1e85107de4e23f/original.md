```julia
SyntaxNode(source::SourceFile, raw::GreenNode{SyntaxHead};
           keep_parens=false, position::Integer=1)
```

An AST node with a similar layout to `Expr`. Typically constructed from source text by calling one of the parser API functions such as [`parseall`](@ref)

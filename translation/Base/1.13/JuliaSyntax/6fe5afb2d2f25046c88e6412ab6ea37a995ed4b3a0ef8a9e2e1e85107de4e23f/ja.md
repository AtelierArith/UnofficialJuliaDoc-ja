```julia
SyntaxNode(source::SourceFile, raw::GreenNode{SyntaxHead};
           keep_parens=false, position::Integer=1)
```

`Expr`と同様の構造を持つASTノード。通常は、[`parseall`](@ref)などのパーサーAPI関数を呼び出して、ソーステキストから構築されます。

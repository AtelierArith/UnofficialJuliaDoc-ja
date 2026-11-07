```julia
is_trivia(x)
```

Return true for "syntax trivia": tokens in the tree which are either largely invisible to the parser (eg, whitespace) or implied by the structure of the AST (eg, reserved words).

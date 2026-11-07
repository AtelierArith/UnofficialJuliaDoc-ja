```julia
paren_type(k::Kind) -> (Int, Symbol)
```

Return a pair of values giving the change in nesting depth caused by the paren `k` (+1 or -1), as well as a symbol indicating the kind of parenthesis:

  * `(` and `)` are a `paren`
  * `[` and `]` are a `bracket`
  * `{` and `}` are a `curly`

Anything else is of type `none`, and produced a depth change of `0`.

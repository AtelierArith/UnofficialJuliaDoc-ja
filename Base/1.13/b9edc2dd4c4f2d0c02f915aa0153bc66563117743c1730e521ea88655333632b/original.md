```julia
quoted(x)
```

Return `x` made safe for inserting as a constant into IR. Note that this does not make it safe for inserting into an AST, since eval will sometimes copy some types of AST object inside, and even may sometimes evaluate and interpolate any `$` inside, depending on the context.

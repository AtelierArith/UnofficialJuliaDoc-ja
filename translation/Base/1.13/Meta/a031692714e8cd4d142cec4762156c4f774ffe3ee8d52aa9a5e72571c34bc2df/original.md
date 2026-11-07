```julia
Meta.unblock(expr)
```

Peel away redundant block expressions.

Specifically, the following expressions are stripped by this function:

  * `:block` expressions with a single non-line-number argument.
  * Pairs of `:var"hygienic-scope"` / `:escape` expressions.

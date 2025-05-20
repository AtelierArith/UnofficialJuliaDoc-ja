```
quote
```

`quote` creates multiple expression objects in a block without using the explicit [`Expr`](@ref) constructor. For example:

```julia
ex = quote
    x = 1
    y = 2
    x + y
end
```

Unlike the other means of quoting, `:( ... )`, this form introduces `QuoteNode` elements to the expression tree, which must be considered when directly manipulating the tree. For other purposes, `:( ... )` and `quote .. end` blocks are treated identically.

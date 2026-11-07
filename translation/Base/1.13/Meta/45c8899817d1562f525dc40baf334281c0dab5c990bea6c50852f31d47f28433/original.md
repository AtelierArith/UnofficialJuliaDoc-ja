```julia
Meta.reescape(unescaped_expr, original_expr)
```

Re-wrap `unescaped_expr` with the same level of escaping as `original_expr` had. This is the inverse operation of [`unescape`](@ref) - if the original expression was escaped, the unescaped expression is wrapped in `:escape` again.

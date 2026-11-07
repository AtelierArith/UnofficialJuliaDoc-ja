```julia
is_aggressive_constprop(method::Union{Method,CodeInfo})::Bool
```

Check if `method` is declared as `Base.@constprop :aggressive`.

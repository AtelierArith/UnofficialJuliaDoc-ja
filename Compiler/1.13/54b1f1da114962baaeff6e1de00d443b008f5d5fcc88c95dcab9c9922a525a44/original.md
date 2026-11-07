```julia
is_identity_free_argtype(argtype)::Bool
```

Return `true` if the `argtype` object is identity free in the sense that this type or any reachable through its fields has non-content-based identity (see `Base.isidentityfree`). This query is specifically designed for `adjust_effects`, enabling it to refine the `:consistent` effect property tainted by mutable allocation(s) within the analyzed call graph when the return value type is `is_identity_free_argtype`, ensuring that the allocated mutable objects are never returned.

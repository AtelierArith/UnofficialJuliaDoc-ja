```julia
Base.isidentityfree(T)
```

Determine whether type `T` is identity free in the sense that this type or any reachable through its fields has non-content-based identity. If `T` is not a type, then return `false`.

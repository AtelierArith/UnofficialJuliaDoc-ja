```julia
struct CachedMethodTable <: MethodTableView
```

Overlays another method table view with an additional local fast path cache that can respond to repeated, identical queries faster than the original method table.

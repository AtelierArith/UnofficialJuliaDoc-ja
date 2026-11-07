```julia
struct OverlayMethodTable <: MethodTableView
```

Overlays the internal method table such that specific queries can be redirected to an external table, e.g., to override existing method.

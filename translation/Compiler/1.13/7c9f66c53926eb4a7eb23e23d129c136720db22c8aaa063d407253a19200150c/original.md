```julia
method_table(interp::AbstractInterpreter)::MethodTableView
```

Returns a method table this `interp` uses for method lookup. External `AbstractInterpreter` can optionally return `OverlayMethodTable` here to incorporate customized dispatches for the overridden methods.

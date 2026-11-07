```julia
legacy_color(color::Union{String, Symbol, Int})
```

Attempt to obtain a `SimpleColor` for a "legacy" color value `color`.

When this is not possible, `nothing` is returned.

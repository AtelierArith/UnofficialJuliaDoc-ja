```julia
Pkg.compat()
```

Interactively edit the [compat] entries within the current Project.

```julia
Pkg.compat(pkg::String, compat::String)
```

Set the [compat] string for the given package within the current Project.

See [Compatibility](@ref) for more information on the project [compat] section.

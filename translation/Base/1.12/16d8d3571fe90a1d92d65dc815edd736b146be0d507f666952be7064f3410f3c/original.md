```julia
Base.isprecompiled(pkg::PkgId; ignore_loaded::Bool=false)
```

Returns whether a given PkgId within the active project is precompiled.

By default this check observes the same approach that code loading takes with respect to when different versions of dependencies are currently loaded to that which is expected. To ignore loaded modules and answer as if in a fresh julia session specify `ignore_loaded=true`.

!!! compat "Julia 1.10"
    This function requires at least Julia 1.10.


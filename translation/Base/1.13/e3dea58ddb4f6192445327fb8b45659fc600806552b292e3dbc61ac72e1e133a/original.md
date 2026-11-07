```julia
Base.isrelocatable(pkg::PkgId)
```

Returns whether a given PkgId within the active project is precompiled and the associated cache is relocatable.

!!! compat "Julia 1.11"
    This function requires at least Julia 1.11.


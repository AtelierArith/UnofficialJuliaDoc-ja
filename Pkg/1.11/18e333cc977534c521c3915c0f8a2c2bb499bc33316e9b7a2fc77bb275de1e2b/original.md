```
Pkg.why(pkg::Union{String, Vector{String}})
Pkg.why(pkg::Union{PackageSpec, Vector{PackageSpec}})
```

Show the reason why this package is in the manifest. The output is all the different ways to reach the package through the dependency graph starting from the dependencies.

!!! compat "Julia 1.9"
    This function requires at least Julia 1.9.


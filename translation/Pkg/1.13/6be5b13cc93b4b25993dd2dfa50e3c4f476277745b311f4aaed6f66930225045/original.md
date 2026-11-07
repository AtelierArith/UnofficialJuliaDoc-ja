```julia
Pkg.why(pkg::Union{String, Vector{String}}; workspace::Bool=false)
Pkg.why(pkg::Union{PackageSpec, Vector{PackageSpec}}; workspace::Bool=false)
```

Show the reason why this package is in the manifest. The output is all the different ways to reach the package through the dependency graph starting from the dependencies. If `workspace` is true, this will consider all projects in the workspace and not just the active one.

!!! compat "Julia 1.9"
    This function requires at least Julia 1.9.


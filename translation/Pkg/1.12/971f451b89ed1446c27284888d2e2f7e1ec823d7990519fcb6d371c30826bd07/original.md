```julia
Pkg.free(pkg::Union{String, Vector{String}}; io::IO=stderr, all_pkgs::Bool=false)
Pkg.free(pkgs::Union{PackageSpec, Vector{PackageSpec}}; io::IO=stderr, all_pkgs::Bool=false)
```

If `pkg` is pinned, remove the pin. If `pkg` is tracking a path, e.g. after [`Pkg.develop`](@ref), go back to tracking registered versions. To free all dependencies set `all_pkgs=true`.

!!! compat "Julia 1.7"
    The `all_pkgs` kwarg was introduced in julia 1.7.


# Examples

```julia
# Free a single package (remove pin or stop tracking path)
Pkg.free("Package")

# Free multiple packages
Pkg.free(["PackageA", "PackageB"])

# Free all packages in the project
Pkg.free(all_pkgs = true)
```

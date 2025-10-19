```julia
Pkg.pin(pkg::Union{String, Vector{String}}; io::IO=stderr, all_pkgs::Bool=false)
Pkg.pin(pkgs::Union{PackageSpec, Vector{PackageSpec}}; io::IO=stderr, all_pkgs::Bool=false)
```

Pin a package to the current version (or the one given in the `PackageSpec`) or to a certain git revision. A pinned package is never automatically updated: if `pkg` is tracking a path, or a repository, those remain tracked but will not update. To get updates from the origin path or remote repository the package must first be freed.

!!! compat "Julia 1.7"
    The `all_pkgs` kwarg was introduced in julia 1.7.


# Examples

```julia
# Pin a package to its current version
Pkg.pin("Example")

# Pin a package to a specific version
Pkg.pin(name="Example", version="0.3.1")

# Pin all packages in the project
Pkg.pin(all_pkgs = true)
```

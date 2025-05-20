```
Pkg.develop(pkg::Union{String, Vector{String}}; io::IO=stderr, preserve=PRESERVE_TIERED, installed=false)
Pkg.develop(pkgs::Union{PackageSpec, Vector{PackageSpec}}; io::IO=stderr, preserve=PRESERVE_TIERED, installed=false)
```

Make a package available for development by tracking it by path. If `pkg` is given with only a name or by a URL, the package will be downloaded to the location specified by the environment variable `JULIA_PKG_DEVDIR`, with `joinpath(DEPOT_PATH[1],"dev")` being the default.

If `pkg` is given as a local path, the package at that path will be tracked.

The preserve strategies offered by `Pkg.add` are also available via the `preserve` kwarg. See [`Pkg.add`](@ref) for more information.

# Examples

```julia
# By name
Pkg.develop("Example")

# By url
Pkg.develop(url="https://github.com/JuliaLang/Compat.jl")

# By path
Pkg.develop(path="MyJuliaPackages/Package.jl")
```

See also [`PackageSpec`](@ref), [`Pkg.add`](@ref).

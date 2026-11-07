```julia
Pkg.Apps.develop(pkg::Union{String, PackageSpec})
Pkg.Apps.develop(; name, uuid, version, url, rev, path, subdir)
```

Like [`Pkg.Apps.add`](@ref) but the apps run directly from the developed project so changes made to it are immediately reflected in the apps.

# Examples

```julia
Pkg.Apps.develop("Runic")
Pkg.Apps.develop(path = "path/to/Package")
```

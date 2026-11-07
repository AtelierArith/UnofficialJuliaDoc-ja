```julia
Pkg.Apps.add(pkg::Union{String, PackageSpec})
Pkg.Apps.add(; name, uuid, version, url, rev, path, subdir)
```

Install the apps of package `pkg`. The package is installed into an isolated environment and shims for its apps are created in `~/.julia/bin` (which should be added to `PATH`). Apps can be added from a registry, a git URL, or a local path (which needs to be a git repository).

# Examples

```julia
Pkg.Apps.add("Runic")
Pkg.Apps.add(name = "Runic", version = "1.5")
Pkg.Apps.add(url = "https://github.com/fredrikekre/Runic.jl", rev = "master")
Pkg.Apps.add(path = "path/to/Package")
```

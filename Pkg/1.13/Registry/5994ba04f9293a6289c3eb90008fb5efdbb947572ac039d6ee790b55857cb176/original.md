```julia
Pkg.Registry
```

A module for managing Julia package registries.

Registries are repositories that contain metadata about available packages, including their versions, dependencies, and locations. The most common registry is the General registry, which hosts publicly available Julia packages.

# Main Functions

  * [`Pkg.Registry.add`](@ref): Add new package registries
  * [`Pkg.Registry.rm`](@ref): Remove installed registries
  * [`Pkg.Registry.update`](@ref): Update installed registries
  * [`Pkg.Registry.status`](@ref): Display information about available registries

# Examples

```julia
# Add the default registries (typically the General registry)
Pkg.Registry.add()

# Add a specific registry by name, UUID, or URL
Pkg.Registry.add("General")
Pkg.Registry.add(url = "https://github.com/JuliaRegistries/General.git")

# Update all registries
Pkg.Registry.update()

# Check registry status
Pkg.Registry.status()

# Remove a registry
Pkg.Registry.rm("General")
```

See also: [`RegistrySpec`](@ref)

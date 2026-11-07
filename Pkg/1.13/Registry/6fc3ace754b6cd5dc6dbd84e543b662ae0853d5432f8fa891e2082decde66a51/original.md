```julia
Pkg.Registry.update()
Pkg.Registry.update(registry::RegistrySpec)
Pkg.Registry.update(registry::Vector{RegistrySpec})
```

Update registries. If no registries are given, update all available registries.

# Examples

```julia
Pkg.Registry.update()
Pkg.Registry.update("General")
Pkg.Registry.update(uuid = "23338594-aafe-5451-b93e-139f81909106")
```

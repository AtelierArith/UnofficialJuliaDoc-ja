```julia
Pkg.Registry.add(registry::RegistrySpec)
```

Add new package registries.

The no-argument `Pkg.Registry.add()` will install the default registries.

# Examples

```julia
Pkg.Registry.add("General")
Pkg.Registry.add(uuid = "23338594-aafe-5451-b93e-139f81909106")
Pkg.Registry.add(url = "https://github.com/JuliaRegistries/General.git")
```

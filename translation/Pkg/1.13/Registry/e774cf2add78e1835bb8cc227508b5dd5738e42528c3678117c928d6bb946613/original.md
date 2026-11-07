```julia
Pkg.Registry.rm(registry::String)
Pkg.Registry.rm(registry::RegistrySpec)
```

Remove registries.

# Examples

```julia
Pkg.Registry.rm("General")
Pkg.Registry.rm(uuid = "23338594-aafe-5451-b93e-139f81909106")
```

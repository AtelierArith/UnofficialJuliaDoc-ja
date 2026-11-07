```julia
Pkg.Registry.update()
Pkg.Registry.update(registry::RegistrySpec)
Pkg.Registry.update(registry::Vector{RegistrySpec})
```

レジストリを更新します。レジストリが指定されていない場合は、利用可能なすべてのレジストリを更新します。

# Examples

```julia
Pkg.Registry.update()
Pkg.Registry.update("General")
Pkg.Registry.update(uuid = "23338594-aafe-5451-b93e-139f81909106")
```

```julia
RegistrySpec(name::String)
RegistrySpec(; name, uuid, url, path)
```

A `RegistrySpec` is a representation of a registry with various metadata, much like [`PackageSpec`](@ref). This includes:

  * The `name` of the registry.
  * The registry's unique `uuid`.
  * The `url` to the registry.
  * A local `path`.

Most registry functions in Pkg take a `Vector` of `RegistrySpec` and do the operation on all the registries in the vector.

Many functions that take a `RegistrySpec` can be called with a more concise notation with keyword arguments. For example, `Pkg.Registry.add` can be called either as the explicit or concise versions as:

| Explicit                                                                                | Concise                                                                    |
|:--------------------------------------------------------------------------------------- |:-------------------------------------------------------------------------- |
| `Pkg.Registry.add(RegistrySpec(name="General"))`                                        | `Pkg.Registry.add(name = "General")`                                       |
| `Pkg.Registry.add(RegistrySpec(url="https://github.com/JuliaRegistries/General.git")))` | `Pkg.Registry.add(url = "https://github.com/JuliaRegistries/General.git")` |

Below is a comparison between the REPL mode and the functional API::

| `REPL`               | `API`                                             |
|:-------------------- |:------------------------------------------------- |
| `MyRegistry`         | `RegistrySpec("MyRegistry")`                      |
| `MyRegistry=a67d...` | `RegistrySpec(name="MyRegistry", uuid="a67d...")` |
| `local/path`         | `RegistrySpec(path="local/path")`                 |
| `www.myregistry.com` | `RegistrySpec(url="www.myregistry.com")`          |

```julia
RegistrySpec(name::String)
RegistrySpec(; name, uuid, url, path)
```

`RegistrySpec`は、[`PackageSpec`](@ref)のように、さまざまなメタデータを持つレジストリの表現です。これには以下が含まれます：

  * レジストリの`name`。
  * レジストリのユニークな`uuid`。
  * レジストリへの`url`。
  * ローカルの`path`。

Pkgのほとんどのレジストリ関数は、`RegistrySpec`の`Vector`を受け取り、ベクター内のすべてのレジストリに対して操作を行います。

`RegistrySpec`を受け取る多くの関数は、キーワード引数を使ってより簡潔な表記で呼び出すことができます。たとえば、`Pkg.Registry.add`は、明示的なバージョンまたは簡潔なバージョンのいずれかとして呼び出すことができます：

| 明示的                                                                                     | 簡潔                                                                         |
|:--------------------------------------------------------------------------------------- |:-------------------------------------------------------------------------- |
| `Pkg.Registry.add(RegistrySpec(name="General"))`                                        | `Pkg.Registry.add(name = "General")`                                       |
| `Pkg.Registry.add(RegistrySpec(url="https://github.com/JuliaRegistries/General.git")))` | `Pkg.Registry.add(url = "https://github.com/JuliaRegistries/General.git")` |

以下は、REPLモードと関数APIの比較です：

| `REPL`               | `API`                                             |
|:-------------------- |:------------------------------------------------- |
| `MyRegistry`         | `RegistrySpec("MyRegistry")`                      |
| `MyRegistry=a67d...` | `RegistrySpec(name="MyRegistry", uuid="a67d...")` |
| `local/path`         | `RegistrySpec(path="local/path")`                 |
| `www.myregistry.com` | `RegistrySpec(url="www.myregistry.com")`          |

```

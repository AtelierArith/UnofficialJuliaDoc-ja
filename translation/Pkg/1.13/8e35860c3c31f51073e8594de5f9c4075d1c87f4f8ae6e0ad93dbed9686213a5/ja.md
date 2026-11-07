```julia
RegistrySpec(name::String)
RegistrySpec(; name, uuid, url, path)
```

`RegistrySpec`は、[`PackageSpec`](@ref)と同様に、さまざまなメタデータを持つレジストリを表します。これには次の情報が含まれます。

  * レジストリの`name`。
  * レジストリ固有の`uuid`。
  * レジストリへの`url`。
  * ローカルの`path`。

Pkgのレジストリ関連関数の多くは、`RegistrySpec`の`Vector`を受け取り、ベクター内のすべてのレジストリに対して処理を実行します。

`RegistrySpec`を受け取る関数の多くは、キーワード引数を使った簡潔な記法でも呼び出せます。たとえば、`Pkg.Registry.add`は、明示的な記法と簡潔な記法のどちらでも、次のように呼び出せます。

| 明示的な記法                                                                                  | 簡潔な記法                                                                      |
|:--------------------------------------------------------------------------------------- |:-------------------------------------------------------------------------- |
| `Pkg.Registry.add(RegistrySpec(name="General"))`                                        | `Pkg.Registry.add(name = "General")`                                       |
| `Pkg.Registry.add(RegistrySpec(url="https://github.com/JuliaRegistries/General.git")))` | `Pkg.Registry.add(url = "https://github.com/JuliaRegistries/General.git")` |

以下に、REPLモードと関数APIの比較を示します。

| `REPL`               | `API`                                             |
|:-------------------- |:------------------------------------------------- |
| `MyRegistry`         | `RegistrySpec("MyRegistry")`                      |
| `MyRegistry=a67d...` | `RegistrySpec(name="MyRegistry", uuid="a67d...")` |
| `local/path`         | `RegistrySpec(path="local/path")`                 |
| `www.myregistry.com` | `RegistrySpec(url="www.myregistry.com")`          |

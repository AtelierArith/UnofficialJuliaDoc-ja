```julia
Pkg.Registry.add(registry::RegistrySpec)
```

新しいパッケージレジストリを追加します。

引数なしの`Pkg.Registry.add()`を実行すると、デフォルトのレジストリがインストールされます。

# Examples

```julia
Pkg.Registry.add("General")
Pkg.Registry.add(uuid = "23338594-aafe-5451-b93e-139f81909106")
Pkg.Registry.add(url = "https://github.com/JuliaRegistries/General.git")
```

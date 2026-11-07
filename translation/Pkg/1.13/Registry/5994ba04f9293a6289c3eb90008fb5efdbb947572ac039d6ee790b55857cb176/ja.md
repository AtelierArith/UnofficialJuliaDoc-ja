```julia
Pkg.Registry
```

Juliaのパッケージレジストリを管理するモジュールです。

レジストリは、利用可能なパッケージのバージョン、依存関係、配置場所などのメタデータを含むリポジトリです。最も一般的なレジストリはGeneralレジストリで、公開されているJuliaパッケージをホストしています。

# Main Functions

  * [`Pkg.Registry.add`](@ref): パッケージレジストリを追加する
  * [`Pkg.Registry.rm`](@ref): インストール済みのレジストリを削除する
  * [`Pkg.Registry.update`](@ref): インストール済みのレジストリを更新する
  * [`Pkg.Registry.status`](@ref): 利用可能なレジストリの情報を表示する

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

関連項目: [`RegistrySpec`](@ref)

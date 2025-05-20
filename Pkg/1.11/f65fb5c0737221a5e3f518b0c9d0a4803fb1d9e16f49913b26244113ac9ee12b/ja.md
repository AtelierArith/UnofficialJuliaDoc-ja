```
Pkg.update(; level::UpgradeLevel=UPLEVEL_MAJOR, mode::PackageMode = PKGMODE_PROJECT, preserve::PreserveLevel)
Pkg.update(pkg::Union{String, Vector{String}})
Pkg.update(pkg::Union{PackageSpec, Vector{PackageSpec}})
```

位置引数が指定されていない場合、`mode`が`PKGMODE_MANIFEST`であればマニフェスト内のすべてのパッケージが更新され、`mode`が`PKGMODE_PROJECT`であればマニフェストとプロジェクトの両方のパッケージが更新されます。位置引数が指定されていない場合、`level`を使用してパッケージのアップグレードを許可する程度（メジャー、マイナー、パッチ、固定）を制御できます。

位置引数としてパッケージが指定されている場合、`preserve`引数を使用して他のパッケージの更新を制御できます：

  * `PRESERVE_ALL`（デフォルト）：`pkg`のみの更新を許可します。
  * `PRESERVE_DIRECT`：`pkg`とプロジェクトの直接依存関係ではない間接依存関係のみの更新を許可します。
  * `PRESERVE_NONE`：`pkg`とそのすべての間接依存関係の更新を許可します。

パッケージの更新後、プロジェクトはプリコンパイルされます。詳細は[Environment Precompilation](@ref)を参照してください。

他にも[`PackageSpec`](@ref)、[`PackageMode`](@ref)、[`UpgradeLevel`](@ref)を参照してください。

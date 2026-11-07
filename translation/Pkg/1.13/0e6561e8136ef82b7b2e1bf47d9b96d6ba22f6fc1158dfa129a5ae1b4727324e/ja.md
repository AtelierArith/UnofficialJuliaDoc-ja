```julia
Pkg.update(; level::UpgradeLevel=UPLEVEL_MAJOR, mode::PackageMode = PKGMODE_PROJECT, preserve::PreserveLevel, workspace::Bool = false)
Pkg.update(pkg::Union{String, Vector{String}})
Pkg.update(pkg::Union{PackageSpec, Vector{PackageSpec}})
```

位置引数が指定されていない場合、`mode` が `PKGMODE_MANIFEST` ならマニフェスト内のすべてのパッケージを、`mode` が `PKGMODE_PROJECT` ならマニフェストとプロジェクトの両方に含まれるパッケージを更新します。位置引数が指定されていない場合は、`level` を使って、パッケージのアップグレードをどの範囲まで許可するか（major、minor、patch、fixed）を指定できます。

パッケージを位置引数として指定した場合、`preserve` 引数を使って、ほかにどのパッケージの更新を許可するかを指定できます。

  * `PRESERVE_ALL`（デフォルト）：`pkg` の更新のみを許可します。
  * `PRESERVE_DIRECT`：`pkg` と、プロジェクトの直接依存関係ではない間接依存関係のみ、更新を許可します。
  * `PRESERVE_NONE`：`pkg` と、そのすべての間接依存関係の更新を許可します。

`workspace` が `true` の場合、パッケージを指定せずに実行すると、ワークスペース内のすべてのプロジェクトのパッケージが対象になります。

パッケージの更新後、プロジェクトはプリコンパイルされます。詳しくは [Environment Precompilation](@ref) を参照してください。

[`PackageSpec`](@ref)、[`PackageMode`](@ref)、[`UpgradeLevel`](@ref) も参照してください。

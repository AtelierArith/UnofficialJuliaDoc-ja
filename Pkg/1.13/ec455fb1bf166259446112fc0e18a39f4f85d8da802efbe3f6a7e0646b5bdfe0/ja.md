```julia
Pkg.pin(pkg::Union{String, Vector{String}}; io::IO=stderr, all_pkgs::Bool=false, workspace::Bool=false)
Pkg.pin(pkgs::Union{PackageSpec, Vector{PackageSpec}}; io::IO=stderr, all_pkgs::Bool=false, workspace::Bool=false)
```

パッケージを現在のバージョン（または`PackageSpec`で指定したバージョン）または特定のGitリビジョンに固定します。固定されたパッケージは自動更新されません。`pkg`がパスまたはリポジトリを追跡している場合も、追跡は継続されますが、更新はされません。元のパスまたはリモートリポジトリから更新を取得するには、まずパッケージの固定を解除する必要があります。

`workspace`が`true`で、`all_pkgs`が`true`の場合、ワークスペース内のすべてのプロジェクトのパッケージが対象になります。

!!! compat "Julia 1.7"
    `all_pkgs`キーワード引数はJulia 1.7で導入されました。


# Examples

```julia
# Pin a package to its current version
Pkg.pin("Example")

# Pin a package to a specific version
Pkg.pin(name="Example", version="0.3.1")

# Pin all packages in the project
Pkg.pin(all_pkgs = true)
```

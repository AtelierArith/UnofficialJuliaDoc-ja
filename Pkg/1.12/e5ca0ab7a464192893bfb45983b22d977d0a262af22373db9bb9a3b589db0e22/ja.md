```julia
Pkg.pin(pkg::Union{String, Vector{String}}; io::IO=stderr, all_pkgs::Bool=false)
Pkg.pin(pkgs::Union{PackageSpec, Vector{PackageSpec}}; io::IO=stderr, all_pkgs::Bool=false)
```

パッケージを現在のバージョン（または `PackageSpec` で指定されたバージョン）または特定の git リビジョンに固定します。固定されたパッケージは自動的に更新されることはありません：`pkg` がパスまたはリポジトリを追跡している場合、それらは追跡されたままですが、更新はされません。元のパスまたはリモートリポジトリからの更新を取得するには、パッケージを最初に解放する必要があります。

!!! compat "Julia 1.7"
    `all_pkgs` キーワード引数は Julia 1.7 で導入されました。


# 例

```julia
# パッケージを現在のバージョンに固定する
Pkg.pin("Example")

# パッケージを特定のバージョンに固定する
Pkg.pin(name="Example", version="0.3.1")

# プロジェクト内のすべてのパッケージを固定する
Pkg.pin(all_pkgs = true)
```

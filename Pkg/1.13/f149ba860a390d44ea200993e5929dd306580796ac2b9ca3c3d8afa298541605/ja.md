```julia
Pkg.free(pkg::Union{String, Vector{String}}; io::IO=stderr, all_pkgs::Bool=false, workspace::Bool=false)
Pkg.free(pkgs::Union{PackageSpec, Vector{PackageSpec}}; io::IO=stderr, all_pkgs::Bool=false, workspace::Bool=false)
```

`pkg` がピン留めされている場合は、ピン留めを解除します。`pkg` がパスを追跡している場合（たとえば [`Pkg.develop`](@ref) の後など）は、登録済みバージョンの追跡に戻します。すべての依存関係を解放するには、`all_pkgs=true` を設定します。

`workspace` が `true` で、`all_pkgs` が `true` の場合、ワークスペース内のすべてのプロジェクトのパッケージが含まれます。

!!! compat "Julia 1.7"
    `all_pkgs` キーワード引数は Julia 1.7 で導入されました。


# Examples

```julia
# Free a single package (remove pin or stop tracking path)
Pkg.free("Package")

# Free multiple packages
Pkg.free(["PackageA", "PackageB"])

# Free all packages in the project
Pkg.free(all_pkgs = true)
```

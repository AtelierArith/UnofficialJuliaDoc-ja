```
Pkg.free(pkg::Union{String, Vector{String}}; io::IO=stderr, all_pkgs::Bool=false)
Pkg.free(pkgs::Union{PackageSpec, Vector{PackageSpec}}; io::IO=stderr, all_pkgs::Bool=false)
```

`pkg`がピン留めされている場合は、ピンを削除します。`pkg`がパスを追跡している場合、例えば[`Pkg.develop`](@ref)の後は、登録されたバージョンの追跡に戻ります。すべての依存関係を解放するには、`all_pkgs=true`を設定します。

!!! compat "Julia 1.7"
    `all_pkgs`キーワード引数はjulia 1.7で導入されました。


# 例

```julia
Pkg.free("Package")
Pkg.free(all_pkgs = true)
```

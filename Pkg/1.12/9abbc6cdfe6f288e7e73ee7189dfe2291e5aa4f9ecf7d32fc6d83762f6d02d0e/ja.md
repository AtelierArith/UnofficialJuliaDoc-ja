```julia
Pkg.rm(pkg::Union{String, Vector{String}}; mode::PackageMode = PKGMODE_PROJECT)
Pkg.rm(pkg::Union{PackageSpec, Vector{PackageSpec}}; mode::PackageMode = PKGMODE_PROJECT)
```

現在のプロジェクトからパッケージを削除します。`mode`が`PKGMODE_MANIFEST`に等しい場合は、`pkg`のすべての再帰的依存関係を含めてマニフェストからも削除します。

参照してください [`PackageSpec`](@ref), [`PackageMode`](@ref).

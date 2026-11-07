```julia
Pkg.rm(pkg::Union{String, Vector{String}}; mode::PackageMode = PKGMODE_PROJECT)
Pkg.rm(pkg::Union{PackageSpec, Vector{PackageSpec}}; mode::PackageMode = PKGMODE_PROJECT)
```

現在のプロジェクトからパッケージを削除します。`mode` が `PKGMODE_MANIFEST` と等しい場合は、`pkg` のすべての再帰的な依存関係も含めて、マニフェストからも削除します。

関連項目: [`PackageSpec`](@ref)、[`PackageMode`](@ref)。

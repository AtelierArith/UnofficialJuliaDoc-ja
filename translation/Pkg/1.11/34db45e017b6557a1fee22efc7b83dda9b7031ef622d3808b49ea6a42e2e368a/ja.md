```
Pkg.rm(pkg::Union{String, Vector{String}}; mode::PackageMode = PKGMODE_PROJECT)
Pkg.rm(pkg::Union{PackageSpec, Vector{PackageSpec}}; mode::PackageMode = PKGMODE_PROJECT)
```

現在のプロジェクトからパッケージを削除します。`mode`が`PKGMODE_MANIFEST`と等しい場合、`pkg`のすべての再帰的依存関係を含めてマニフェストからも削除します。

関連情報として[`PackageSpec`](@ref)、[`PackageMode`](@ref)を参照してください。

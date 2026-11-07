```julia
PackageMode
```

次のインスタンスを持つ列挙型です。

  * `PKGMODE_MANIFEST`
  * `PKGMODE_PROJECT`

操作をプロジェクトレベルで行うか、マニフェストレベルで行うかを指定します。[`Pkg.rm`](@ref)、[`Pkg.update`](@ref)、[`Pkg.status`](@ref)の引数として使用されます。

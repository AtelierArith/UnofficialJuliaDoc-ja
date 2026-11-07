```julia
UpgradeLevel
```

次のインスタンスを持つ列挙型です。

  * `UPLEVEL_FIXED`
  * `UPLEVEL_PATCH`
  * `UPLEVEL_MINOR`
  * `UPLEVEL_MAJOR`

パッケージに許可される更新の範囲を決定します。[`PackageSpec`](@ref)または[`Pkg.update`](@ref)の引数として使用します。

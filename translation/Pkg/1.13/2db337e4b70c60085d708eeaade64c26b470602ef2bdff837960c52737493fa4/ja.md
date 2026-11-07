```julia
UpgradeLevel
```

次のインスタンスを持つ列挙型です。

  * `UPLEVEL_FIXED`
  * `UPLEVEL_PATCH`
  * `UPLEVEL_MINOR`
  * `UPLEVEL_MAJOR`

パッケージの更新をどこまで許可するかを指定します。[`PackageSpec`](@ref)または[`Pkg.update`](@ref)の引数として使用します。

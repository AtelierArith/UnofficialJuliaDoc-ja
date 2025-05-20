```
UpgradeLevel
```

インスタンスを持つ列挙型

  * `UPLEVEL_FIXED`
  * `UPLEVEL_PATCH`
  * `UPLEVEL_MINOR`
  * `UPLEVEL_MAJOR`

パッケージがどの程度更新されることが許可されるかを決定します。 [`PackageSpec`](@ref) への引数や [`Pkg.update`](@ref) への引数として使用されます。

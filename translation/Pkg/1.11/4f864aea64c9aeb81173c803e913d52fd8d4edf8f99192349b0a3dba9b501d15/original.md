```
UpgradeLevel
```

An enum with the instances

  * `UPLEVEL_FIXED`
  * `UPLEVEL_PATCH`
  * `UPLEVEL_MINOR`
  * `UPLEVEL_MAJOR`

Determines how much a package is allowed to be updated. Used as an argument to  [`PackageSpec`](@ref) or as an argument to [`Pkg.update`](@ref).

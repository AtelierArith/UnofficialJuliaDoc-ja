```julia
PackageMode
```

An enum with the instances

  * `PKGMODE_MANIFEST`
  * `PKGMODE_PROJECT`

Determines if operations should be made on a project or manifest level. Used as an argument to [`Pkg.rm`](@ref), [`Pkg.update`](@ref) and [`Pkg.status`](@ref).

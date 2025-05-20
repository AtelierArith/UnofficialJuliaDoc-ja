```
Pkg.update(; level::UpgradeLevel=UPLEVEL_MAJOR, mode::PackageMode = PKGMODE_PROJECT, preserve::PreserveLevel)
Pkg.update(pkg::Union{String, Vector{String}})
Pkg.update(pkg::Union{PackageSpec, Vector{PackageSpec}})
```

If no positional argument is given, update all packages in the manifest if `mode` is `PKGMODE_MANIFEST` and packages in both manifest and project if `mode` is `PKGMODE_PROJECT`. If no positional argument is given, `level` can be used to control by how much packages are allowed to be upgraded (major, minor, patch, fixed).

If packages are given as positional arguments, the `preserve` argument can be used to control what other packages are allowed to update:

  * `PRESERVE_ALL` (default): Only allow `pkg` to update.
  * `PRESERVE_DIRECT`: Only allow `pkg` and indirect dependencies that are not a direct dependency in the project to update.
  * `PRESERVE_NONE`: Allow `pkg` and all its indirect dependencies to update.

After any package updates the project will be precompiled. See more at [Environment Precompilation](@ref).

See also [`PackageSpec`](@ref), [`PackageMode`](@ref), [`UpgradeLevel`](@ref).

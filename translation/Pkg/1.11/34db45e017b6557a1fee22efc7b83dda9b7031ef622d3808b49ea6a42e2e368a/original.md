```
Pkg.rm(pkg::Union{String, Vector{String}}; mode::PackageMode = PKGMODE_PROJECT)
Pkg.rm(pkg::Union{PackageSpec, Vector{PackageSpec}}; mode::PackageMode = PKGMODE_PROJECT)
```

Remove a package from the current project. If `mode` is equal to `PKGMODE_MANIFEST` also remove it from the manifest including all recursive dependencies of `pkg`.

See also [`PackageSpec`](@ref), [`PackageMode`](@ref).

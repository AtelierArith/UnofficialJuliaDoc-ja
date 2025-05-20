```
Pkg.status([pkgs...]; outdated::Bool=false, mode::PackageMode=PKGMODE_PROJECT, diff::Bool=false, compat::Bool=false, extensions::Bool=false, io::IO=stdout)
```

Print out the status of the project/manifest.

Packages marked with `⌃` have new versions that can be installed, e.g. via [`Pkg.update`](@ref). Those marked with `⌅` have new versions available, but cannot be installed due to compatibility conflicts with other packages. To see why, set the keyword argument `outdated=true`.

Setting `outdated=true` will only show packages that are not on the latest version, their maximum version and why they are not on the latest version (either due to other packages holding them back due to compatibility constraints, or due to compatibility in the project file). As an example, a status output like:

```
pkg> Pkg.status(; outdated=true)
Status `Manifest.toml`
⌃ [a8cc5b0e] Crayons v2.0.0 [<v3.0.0], (<v4.0.4)
⌅ [b8a86587] NearestNeighbors v0.4.8 (<v0.4.9) [compat]
⌅ [2ab3a3ac] LogExpFunctions v0.2.5 (<v0.3.0): SpecialFunctions
```

means that the latest version of Crayons is 4.0.4 but the latest version compatible with the `[compat]` section in the current project is 3.0.0. The latest version of NearestNeighbors is 0.4.9 but due to compat constrains in the project it is held back to 0.4.8. The latest version of LogExpFunctions is 0.3.0 but SpecialFunctions is holding it back to 0.2.5.

If `mode` is `PKGMODE_PROJECT`, print out status only about the packages that are in the project (explicitly added). If `mode` is `PKGMODE_MANIFEST`, print status also about those in the manifest (recursive dependencies). If there are any packages listed as arguments, the output will be limited to those packages.

Setting `ext=true` will show dependencies with extensions and what extension dependencies of those that are currently loaded.

Setting `diff=true` will, if the environment is in a git repository, limit the output to the difference as compared to the last git commit.

See [`Pkg.project`](@ref) and [`Pkg.dependencies`](@ref) to get the project/manifest status as a Julia object instead of printing it.

!!! compat "Julia 1.8"
    The `⌃` and `⌅` indicators were added in Julia 1.8. The `outdated` keyword argument requires at least Julia 1.8.


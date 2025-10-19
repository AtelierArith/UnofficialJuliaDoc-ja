```julia
Pkg.instantiate(; verbose = false, workspace=false, io::IO=stderr, julia_version_strict=false)
```

If a `Manifest.toml` file exists in the active project, download all the packages declared in that manifest. Otherwise, resolve a set of feasible packages from the `Project.toml` files and install them. `verbose = true` prints the build output to `stdout`/`stderr` instead of redirecting to the `build.log` file. `workspace=true` will also instantiate all projects in the workspace. If no `Project.toml` exist in the current active project, create one with all the dependencies in the manifest and instantiate the resulting project. `julia_version_strict=true` will turn manifest version check failures into errors instead of logging warnings.

After packages have been installed the project will be precompiled. See more at [Environment Precompilation](@ref).

!!! compat "Julia 1.12"
    The `julia_version_strict` keyword argument requires at least Julia 1.12.


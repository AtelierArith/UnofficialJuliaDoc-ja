```
Pkg.instantiate(; verbose = false, io::IO=stderr)
```

If a `Manifest.toml` file exists in the active project, download all the packages declared in that manifest. Otherwise, resolve a set of feasible packages from the `Project.toml` files and install them. `verbose = true` prints the build output to `stdout`/`stderr` instead of redirecting to the `build.log` file. If no `Project.toml` exist in the current active project, create one with all the dependencies in the manifest and instantiate the resulting project.

After packages have been installed the project will be precompiled. See more at [Environment Precompilation](@ref).

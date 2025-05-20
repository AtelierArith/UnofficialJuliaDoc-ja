```
pkgversion(m::Module)
```

Return the version of the package that imported module `m`, or `nothing` if `m` was not imported from a package, or imported from a package without a version field set.

The version is read from the package's Project.toml during package load.

To get the version of the package that imported the current module the form `pkgversion(@__MODULE__)` can be used.

!!! compat "Julia 1.9"
    This function was introduced in Julia 1.9.


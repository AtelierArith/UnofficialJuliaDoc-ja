```julia
pkgversion(m::Module)
```

If the module `m` belongs to a versioned package, return the version number of that package. Otherwise return `nothing`.

The version is read from the package's Project.toml during package load.

To get the version of the package that imported the current module the form `pkgversion(@__MODULE__)` can be used.

!!! compat "Julia 1.9"
    This function was introduced in Julia 1.9.


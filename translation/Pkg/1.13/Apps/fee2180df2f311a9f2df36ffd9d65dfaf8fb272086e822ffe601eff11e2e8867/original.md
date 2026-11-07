```julia
Pkg.Apps.rm(name::String)
```

Remove the app `name`, or all apps of the package named `name`. This removes the shims from `~/.julia/bin` and, when the last app of a package is removed, its app environment.

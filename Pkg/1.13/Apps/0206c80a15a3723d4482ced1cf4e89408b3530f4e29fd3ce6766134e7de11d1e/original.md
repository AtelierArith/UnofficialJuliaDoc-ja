```julia
Pkg.Apps.update(name::Union{Nothing, String} = nothing)
```

Update the package providing the app `name` (or the package named `name`) to the latest compatible version, or all installed apps if no name is given. For developed packages the dependencies of the project are updated instead.

```julia
Pkg.Apps.status(name::Union{Nothing, String} = nothing)
```

Show the installed apps, the version of their package, and the julia command used to run them. If `name` is given, limit the output to that app or package.

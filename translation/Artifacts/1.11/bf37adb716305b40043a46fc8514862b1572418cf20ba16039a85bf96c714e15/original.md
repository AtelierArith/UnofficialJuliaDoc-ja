```julia
find_artifacts_toml(path::String)
```

Given the path to a `.jl` file, (such as the one returned by `__source__.file` in a macro context), find the `(Julia)Artifacts.toml` that is contained within the containing project (if it exists), otherwise return `nothing`.

!!! compat "Julia 1.3"
    This function requires at least Julia 1.3.


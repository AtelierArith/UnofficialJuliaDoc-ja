```julia
GitConfig(path::AbstractString, level::Consts.GIT_CONFIG=Consts.CONFIG_LEVEL_APP, force::Bool=false)
```

Create a new `GitConfig` by loading configuration information from the file at `path`. See [`addfile`](@ref) for more information about the `level`, `repo` and `force` options.

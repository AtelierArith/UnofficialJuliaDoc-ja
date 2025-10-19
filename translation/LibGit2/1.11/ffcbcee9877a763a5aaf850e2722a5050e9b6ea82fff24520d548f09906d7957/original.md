```julia
addfile(cfg::GitConfig, path::AbstractString,
        level::Consts.GIT_CONFIG=Consts.CONFIG_LEVEL_APP,
        repo::Union{GitRepo, Nothing} = nothing,
        force::Bool=false)
```

Add an existing git configuration file located at `path` to the current `GitConfig` `cfg`. If the file does not exist, it will be created.

  * `level` sets the git configuration priority level and is determined by

[`Consts.GIT_CONFIG`](@ref).

  * `repo` is an optional repository to allow parsing of conditional includes.
  * If `force` is `false` and a configuration for the given priority level already exists,

`addfile` will error. If `force` is `true`, the existing configuration will be replaced by the one in the file at `path`.

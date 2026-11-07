```julia
GitConfig(path::AbstractString, level::Consts.GIT_CONFIG=Consts.CONFIG_LEVEL_APP, force::Bool=false)
```

`path` のファイルから設定情報を読み込んで、新しい `GitConfig` を作成します。`level`、`repo`、`force` の各オプションの詳細については、[`addfile`](@ref) を参照してください。

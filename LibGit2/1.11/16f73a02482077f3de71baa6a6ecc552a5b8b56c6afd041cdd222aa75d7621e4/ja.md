```julia
addfile(cfg::GitConfig, path::AbstractString,
        level::Consts.GIT_CONFIG=Consts.CONFIG_LEVEL_APP,
        repo::Union{GitRepo, Nothing} = nothing,
        force::Bool=false)
```

既存の Git 設定ファイル `path` を、現在の `GitConfig` `cfg` に追加します。ファイルが存在しない場合は作成されます。

  * `level` は Git 設定の優先度レベルを指定します。優先度レベルは

[`Consts.GIT_CONFIG`](@ref)

によって決まります。

  * `repo` は、条件付きインクルードを解析するための任意のリポジトリです。
  * `force` が `false` で、指定された優先度レベルの設定がすでに存在する場合、

`addfile` はエラーになります。`force` が `true` の場合、既存の設定は `path` のファイル内の設定で置き換えられます。

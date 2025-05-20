```
addfile(cfg::GitConfig, path::AbstractString,
        level::Consts.GIT_CONFIG=Consts.CONFIG_LEVEL_APP,
        repo::Union{GitRepo, Nothing} = nothing,
        force::Bool=false)
```

`path` にある既存の git 設定ファイルを現在の `GitConfig` `cfg` に追加します。ファイルが存在しない場合は、作成されます。

  * `level` は git 設定の優先度レベルを設定し、[`Consts.GIT_CONFIG`](@ref) によって決定されます。
  * `repo` は条件付きインクルードの解析を許可するオプションのリポジトリです。
  * `force` が `false` の場合、指定された優先度レベルの設定がすでに存在する場合は、`addfile` はエラーになります。`force` が `true` の場合、既存の設定は `path` にあるファイルのものに置き換えられます。

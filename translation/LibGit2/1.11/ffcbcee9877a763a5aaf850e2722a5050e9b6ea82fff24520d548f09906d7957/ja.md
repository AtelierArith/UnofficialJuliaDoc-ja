```julia
addfile(cfg::GitConfig, path::AbstractString,
        level::Consts.GIT_CONFIG=Consts.CONFIG_LEVEL_APP,
        repo::Union{GitRepo, Nothing} = nothing,
        force::Bool=false)
```

既存のgit構成ファイルを`path`にある場所から現在の`GitConfig` `cfg`に追加します。ファイルが存在しない場合は、作成されます。

  * `level`はgit構成の優先度レベルを設定し、[`Consts.GIT_CONFIG`](@ref)によって決定されます。
  * `repo`は条件付きインクルードの解析を許可するオプションのリポジトリです。
  * `force`が`false`で、指定された優先度レベルの構成がすでに存在する場合、

`addfile`はエラーになります。`force`が`true`の場合、既存の構成は`path`にあるファイルのものに置き換えられます。

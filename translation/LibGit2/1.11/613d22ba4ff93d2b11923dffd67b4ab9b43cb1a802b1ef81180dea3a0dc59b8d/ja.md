```
GitConfig(path::AbstractString, level::Consts.GIT_CONFIG=Consts.CONFIG_LEVEL_APP, force::Bool=false)
```

`path`で指定されたファイルから設定情報を読み込むことによって新しい`GitConfig`を作成します。`level`、`repo`、および`force`オプションに関する詳細は[`addfile`](@ref)を参照してください。

```julia
GitConfig(path::AbstractString, level::Consts.GIT_CONFIG=Consts.CONFIG_LEVEL_APP, force::Bool=false)
```

`path`にあるファイルから設定情報を読み込むことで新しい`GitConfig`を作成します。`level`、`repo`、および`force`オプションの詳細については[`addfile`](@ref)を参照してください。

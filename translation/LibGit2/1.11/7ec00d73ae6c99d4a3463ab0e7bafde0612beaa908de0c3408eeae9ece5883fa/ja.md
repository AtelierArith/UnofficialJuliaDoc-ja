```julia
GitConfig(level::Consts.GIT_CONFIG=Consts.CONFIG_LEVEL_DEFAULT)
```

グローバルおよびシステム設定ファイルを優先順位の付いた設定に読み込むことで、デフォルトのgit設定を取得します。これは、特定のgitリポジトリの外部でデフォルトの設定オプションにアクセスするために使用できます。

```julia
GitConfig(level::Consts.GIT_CONFIG=Consts.CONFIG_LEVEL_DEFAULT)
```

グローバルおよびシステムの設定ファイルを読み込み、優先順位を付けた設定としてデフォルトの Git 設定を取得します。これにより、特定の Git リポジトリに依存せず、デフォルトの設定オプションにアクセスできます。

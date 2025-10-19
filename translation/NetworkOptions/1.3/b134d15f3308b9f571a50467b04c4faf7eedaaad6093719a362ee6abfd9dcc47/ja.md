```julia
ssh_key_path() :: String
```

`ssh_key_path()` 関数は、SSH 接続に使用すべき SSH プライベートキー ファイルのパスを返します。`SSH_KEY_PATH` 環境変数が設定されている場合は、その値を返します。そうでない場合は、次の値を返すのがデフォルトです。

```julia
joinpath(ssh_dir(), ssh_key_name())
```

このデフォルト値は、`SSH_DIR` および `SSH_KEY_NAME` 環境変数に依存します。

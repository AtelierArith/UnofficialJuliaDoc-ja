```julia
ssh_key_path() :: String
```

`ssh_key_path()` 関数は、SSH 接続に使用する SSH 秘密鍵ファイルのパスを返します。`SSH_KEY_PATH` 環境変数が設定されている場合は、その値を返します。設定されていない場合は、既定で次の値を返します。

```julia
joinpath(ssh_dir(), ssh_key_name())
```

この既定値は、`SSH_DIR` 環境変数と `SSH_KEY_NAME` 環境変数にも依存します。

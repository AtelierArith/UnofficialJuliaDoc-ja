```julia
ssh_pub_key_path() :: String
```

`ssh_pub_key_path()` 関数は、SSH 接続に使用する SSH 公開鍵ファイルのパスを返します。`SSH_PUB_KEY_PATH` 環境変数が設定されている場合は、その値を返します。設定されておらず、`SSH_KEY_PATH` が設定されている場合は、そのパスに `.pub` サフィックスを付けて返します。どちらも設定されていない場合は、次の値を返します。

```julia
joinpath(ssh_dir(), ssh_key_name() * ".pub")
```

このデフォルト値は、`SSH_DIR` 環境変数と `SSH_KEY_NAME` 環境変数にも依存します。

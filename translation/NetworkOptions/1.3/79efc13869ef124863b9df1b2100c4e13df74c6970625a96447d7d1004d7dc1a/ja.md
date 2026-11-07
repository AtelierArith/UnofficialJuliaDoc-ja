```julia
ssh_pub_key_path() :: String
```

`ssh_pub_key_path()` 関数は、SSH 接続に使用する SSH 公開鍵ファイルのパスを返します。環境変数 `SSH_PUB_KEY_PATH` が設定されている場合は、その値を返します。設定されておらず、`SSH_KEY_PATH` が設定されている場合は、そのパスに `.pub` のサフィックスを付けて返します。どちらも設定されていない場合は、次の値を返します。

```julia
joinpath(ssh_dir(), ssh_key_name() * ".pub")
```

このデフォルト値は、環境変数 `SSH_DIR` と `SSH_KEY_NAME` によって決まります。

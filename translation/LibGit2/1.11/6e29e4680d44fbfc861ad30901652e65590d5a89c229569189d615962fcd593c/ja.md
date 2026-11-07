```julia
connect(rmt::GitRemote, direction::Consts.GIT_DIRECTION; kwargs...)
```

リモートへの接続を開きます。`direction`には、`DIRECTION_FETCH`または`DIRECTION_PUSH`を指定できます。

キーワード引数は次のとおりです。

  * `credentials::Creds=nothing`: プライベートリポジトリへの認証時に、認証情報や設定を指定します。
  * `callbacks::Callbacks=Callbacks()`: ユーザーが指定するコールバックとペイロードです。

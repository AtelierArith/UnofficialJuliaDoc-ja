```
connect(rmt::GitRemote, direction::Consts.GIT_DIRECTION; kwargs...)
```

リモートへの接続を開きます。`direction` は `DIRECTION_FETCH` または `DIRECTION_PUSH` のいずれかです。

キーワード引数は次のとおりです：

  * `credentials::Creds=nothing`: プライベートリポジトリに対して認証する際に、資格情報および/または設定を提供します。
  * `callbacks::Callbacks=Callbacks()`: ユーザー提供のコールバックおよびペイロード。

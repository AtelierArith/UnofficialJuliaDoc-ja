```julia
LibGit2.PushOptions
```

[`git_push_options`](https://libgit2.org/libgit2/#HEAD/type/git_push_options) 構造体に一致します。

各フィールドの意味は次のとおりです。

  * `version`: 後で変更される場合に備えた、使用中の構造体のバージョン。現時点では常に `1` です。
  * `parallelism`: pack ファイルを作成する必要がある場合に、packbuilder が起動するワーカースレッド数を設定する変数です。`0` の場合、packbuilder が使用するスレッド数を自動的に設定します。デフォルトは `1` です。
  * `callbacks`: push で使用するコールバック（リモートでの認証など）です。
  * `proxy_opts`: LibGit2 のバージョンが `0.25.0` 以上の場合にのみ関係します。リモートとの通信にプロキシを使用するためのオプションを設定します。詳しくは [`ProxyOptions`](@ref) を参照してください。
  * `custom_headers`: LibGit2 のバージョンが `0.24.0` 以上の場合にのみ関係します。push 操作に必要な追加ヘッダーです。
  * `remote_push_options`: LibGit2 のバージョンが `1.8.0` 以上の場合にのみ関係します。リモートに渡す「push オプション」です。

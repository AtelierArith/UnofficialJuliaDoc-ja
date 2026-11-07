```julia
LibGit2.FetchOptions
```

[`git_fetch_options`](https://libgit2.org/libgit2/#HEAD/type/git_fetch_options) 構造体に対応します。

各フィールドの意味は次のとおりです。

  * `version`: 後で変更される場合に備えた、使用中の構造体のバージョン。現時点では常に `1` です。
  * `callbacks`: フェッチ中に使用するリモートコールバック。
  * `prune`: フェッチ後にプルーンを実行するかどうか。デフォルトでは、`GitConfig` の設定が使用されます。
  * `update_fetchhead`: フェッチ後に [`FetchHead`](@ref) を更新するかどうか。デフォルトでは更新が実行されます。これは通常の git の動作です。
  * `download_tags`: リモートにあるタグをダウンロードするかどうか。デフォルトでは、サーバーからダウンロードするオブジェクトに関連するタグを要求します。
  * `proxy_opts`: プロキシ経由でリモートに接続するためのオプション。[`ProxyOptions`](@ref) を参照してください。libgit2 のバージョンが 0.25.0 以降の場合にのみ存在します。
  * `custom_headers`: フェッチに必要な追加ヘッダー。libgit2 のバージョンが 0.24.0 以降の場合にのみ存在します。

```
LibGit2.FetchOptions
```

[`git_fetch_options`](https://libgit2.org/libgit2/#HEAD/type/git_fetch_options) 構造体に対応しています。

フィールドは次のことを表します：

  * `version`: 使用中の構造体のバージョン。将来的に変更される場合に備えています。現時点では常に `1` です。
  * `callbacks`: フェッチ中に使用するリモートコールバック。
  * `prune`: フェッチ後にプルーニングを行うかどうか。デフォルトは `GitConfig` の設定を使用します。
  * `update_fetchhead`: フェッチ後に [`FetchHead`](@ref) を更新するかどうか。デフォルトは更新を行うことで、これは通常の git の動作です。
  * `download_tags`: リモートに存在するタグをダウンロードするかどうか。デフォルトは、サーバーからダウンロードされるオブジェクトのタグをリクエストすることです。
  * `proxy_opts`: プロキシを介してリモートに接続するためのオプション。[`ProxyOptions`](@ref) を参照してください。libgit2 のバージョンが 0.25.0 以上の場合のみ存在します。
  * `custom_headers`: フェッチに必要な追加ヘッダー。libgit2 のバージョンが 0.24.0 以上の場合のみ存在します。

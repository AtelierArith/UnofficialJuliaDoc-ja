```
LibGit2.ProxyOptions
```

プロキシを介して接続するためのオプション。

[`git_proxy_options`](https://libgit2.org/libgit2/#HEAD/type/git_proxy_options) 構造体に対応しています。

フィールドは次のことを表します：

  * `version`: 使用中の構造体のバージョン。将来的に変更される場合に備えています。現時点では常に `1` です。
  * `proxytype`: 使用するプロキシのタイプを示す `enum`。 [`git_proxy_t`](https://libgit2.org/libgit2/#HEAD/type/git_proxy_t) で定義されています。対応するJuliaのenumは `GIT_PROXY` で、値は次の通りです：

      * `PROXY_NONE`: プロキシを介して接続を試みない。
      * `PROXY_AUTO`: gitの設定からプロキシの構成を自動的に判断しようとする。
      * `PROXY_SPECIFIED`: この構造体の `url` フィールドに指定されたURLを使用して接続する。

    デフォルトはプロキシタイプを自動検出することです。
  * `url`: プロキシのURL。
  * `credential_cb`: リモートが接続するために認証を必要とする場合に呼び出されるコールバック関数へのポインタ。
  * `certificate_cb`: 証明書の検証が失敗した場合に呼び出されるコールバック関数へのポインタ。これにより、ユーザーは接続を続けるかどうかを決定できます。関数が `1` を返すと接続が許可されます。 `0` を返すと接続は許可されません。負の値を使用してエラーを返すことができます。
  * `payload`: 2つのコールバック関数に提供されるペイロード。

# 例

```julia-repl
julia> fo = LibGit2.FetchOptions(
           proxy_opts = LibGit2.ProxyOptions(url = Cstring("https://my_proxy_url.com")))

julia> fetch(remote, "master", options=fo)
```

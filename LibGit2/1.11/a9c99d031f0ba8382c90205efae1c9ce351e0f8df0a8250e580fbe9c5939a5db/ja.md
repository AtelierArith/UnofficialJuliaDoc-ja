```julia
LibGit2.ProxyOptions
```

プロキシ経由で接続するためのオプションです。

[`git_proxy_options`](https://libgit2.org/libgit2/#HEAD/type/git_proxy_options) 構造体に対応します。

各フィールドの意味は次のとおりです。

  * `version`: 後で変更される場合に備えた、使用中の構造体のバージョンです。現時点では常に `1` です。
  * `proxytype`: 使用するプロキシの種類を示す `enum` です。定義は [`git_proxy_t`](https://libgit2.org/libgit2/#HEAD/type/git_proxy_t) にあります。対応する Julia の列挙型は `GIT_PROXY` で、次の値を取ります。

      * `PROXY_NONE`: プロキシ経由での接続を試みません。
      * `PROXY_AUTO`: git の設定からプロキシ構成を自動判定します。
      * `PROXY_SPECIFIED`: この構造体の `url` フィールドで指定された URL を使って接続します。

    デフォルトでは、プロキシの種類を自動判定します。
  * `url`: プロキシの URL です。
  * `credential_cb`: リモートへの接続に認証が必要な場合に呼び出されるコールバック関数へのポインターです。
  * `certificate_cb`: 証明書の検証に失敗した場合に呼び出されるコールバック関数へのポインターです。接続を続行するかどうかをユーザーが判断できます。この関数が `1` を返すと接続が許可され、`0` を返すと接続は許可されません。エラーを返すには負の値を使用できます。
  * `payload`: 2 つのコールバック関数に渡されるペイロードです。

# Examples

```julia-repl
julia> fo = LibGit2.FetchOptions(
           proxy_opts = LibGit2.ProxyOptions(url = Cstring("https://my_proxy_url.com")))

julia> fetch(remote, "master", options=fo)
```

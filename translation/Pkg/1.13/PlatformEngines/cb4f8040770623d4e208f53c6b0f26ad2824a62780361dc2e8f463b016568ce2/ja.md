```julia
register_auth_error_handler(urlscheme::Union{AbstractString, Regex}, f)
```

パッケージサーバーの認証に失敗した場合に、最優先で呼び出されるハンドラーとして `f` を登録します。

ハンドラーは、`occursin(urlscheme, url)` が true の場合にのみ呼び出されます（`url` は、Pkg が現在ダウンロードしようとしている URL です）。

`f` は、3 つの引数 `(url, pkgserver, err)` を受け取る関数でなければなりません。`url` は現在ダウンロード中の URL、`pkgserver = Pkg.pkg_server()` は現在のパッケージサーバー、`err` は `no-auth-file`、`insecure-connection`、`malformed-file`、`no-access-token`、`no-refresh-key`、`insecure-refresh-url` のいずれかです。

ハンドラー `f` は、`Bool` のタプル `(handled, should_retry)` を返す必要があります。`handled` が `false` の場合、スタック内の次のハンドラーが呼び出されます。それ以外の場合は処理を終了します。`should_retry` が `true` の場合は、`get_auth_header` が再度呼び出されます。

`register_auth_error_handler` は、ハンドラーの登録解除に使用できる、引数を取らない関数を返します。

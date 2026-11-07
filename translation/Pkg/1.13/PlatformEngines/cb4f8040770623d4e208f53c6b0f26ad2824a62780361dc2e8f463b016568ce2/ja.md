```julia
register_auth_error_handler(urlscheme::Union{AbstractString, Regex}, f)
```

パッケージサーバーの認証失敗を処理する最上位のハンドラーとして、`f`を登録します。

ハンドラーは、`occursin(urlscheme, url)`が真の場合にのみ呼び出されます（`url`は、Pkgが現在ダウンロードしようとしているURLです）。

`f`は、3つの入力引数`(url, pkgserver, err)`を受け取る関数でなければなりません。`url`は現在ダウンロード中のURL、`pkgserver = Pkg.pkg_server()`は現在のパッケージサーバー、`err`は`no-auth-file`、`insecure-connection`、`malformed-file`、`no-access-token`、`no-refresh-key`、`insecure-refresh-url`のいずれかです。

ハンドラー`f`は、`Bool`のタプル`(handled, should_retry)`を返す必要があります。`handled`が`false`の場合、スタック内の次のハンドラーが呼び出されます。それ以外の場合は処理が終了します。`should_retry`が`true`の場合は、`get_auth_header`が再度呼び出されます。

`register_auth_error_handler`は、ハンドラーの登録解除に使用できる、引数を取らない関数を返します。

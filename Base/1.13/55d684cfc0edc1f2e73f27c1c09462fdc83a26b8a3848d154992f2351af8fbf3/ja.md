```julia
Base.getpass(message::AbstractString; with_suffix::Bool=true)::Base.SecretBuffer
```

メッセージを表示し、ユーザーがシークレットを入力するまで待機して、そのシークレットを含む`IO`オブジェクトを返します。`with_suffix`が`true`（デフォルト）の場合、接尾辞`": "`が`message`に追加されます。

!!! info "Windows"
    Windowsでは、入力中のシークレットが画面に表示される場合があります。グラフィカルインターフェースからユーザー名とパスワードを安全に取得する方法については、`Base.winprompt`を参照してください。


!!! compat "Julia 1.12"
    `with_suffix`キーワード引数を使用するには、Julia 1.12以降が必要です。


# Examples

```julia-repl
julia> Base.getpass("Secret")
Secret: SecretBuffer("*******")

julia> Base.getpass("Secret> "; with_suffix=false)
Secret> SecretBuffer("*******")
```

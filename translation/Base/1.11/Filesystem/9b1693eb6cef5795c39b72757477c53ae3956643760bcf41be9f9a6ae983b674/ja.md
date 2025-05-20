```
mktemp(parent=tempdir(); cleanup=true) -> (path, io)
```

`(path, io)`を返します。ここで、`path`は`parent`内の新しい一時ファイルのパスであり、`io`はこのパスのオープンファイルオブジェクトです。`cleanup`オプションは、プロセスが終了したときに一時ファイルが自動的に削除されるかどうかを制御します。

!!! compat "Julia 1.3"
    `cleanup`キーワード引数はJulia 1.3で追加されました。関連して、1.3以降、Juliaプロセスが終了する際に`mktemp`によって作成された一時パスが削除されます。ただし、`cleanup`が明示的に`false`に設定されている場合は除きます。


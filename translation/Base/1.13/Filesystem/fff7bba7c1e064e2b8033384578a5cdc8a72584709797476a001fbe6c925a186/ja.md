```julia
mktemp(parent=tempdir(); cleanup=true) -> (path, io)
```

`(path, io)`を返します。`path`は`parent`内に作成される新しい一時ファイルのパスで、`io`はそのパスに対するオープン済みファイルオブジェクトです。`cleanup`オプションは、プロセス終了時に一時ファイルを自動的に削除するかどうかを制御します。

!!! compat "Julia 1.3"
    `cleanup`キーワード引数はJulia 1.3で追加されました。関連して、1.3以降、`cleanup`が明示的に`false`に設定されていない限り、Juliaはプロセス終了時に`mktemp`が作成した一時パスを削除します。


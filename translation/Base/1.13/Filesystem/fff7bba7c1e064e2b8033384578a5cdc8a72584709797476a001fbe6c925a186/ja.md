```julia
mktemp(parent=tempdir(); cleanup=true) -> (path, io)
```

`(path, io)`を返します。`path`は`parent`内に作成される新しい一時ファイルのパスで、`io`はそのパスを指すオープン済みのファイルオブジェクトです。一時ファイルをプロセス終了時に自動削除するかどうかは、`cleanup`オプションで制御します。

!!! compat "Julia 1.3"
    `cleanup`キーワード引数はJulia 1.3で追加されました。また、1.3以降では、`cleanup`を明示的に`false`に設定しない限り、Juliaはプロセス終了時に`mktemp`が作成した一時パスを削除します。


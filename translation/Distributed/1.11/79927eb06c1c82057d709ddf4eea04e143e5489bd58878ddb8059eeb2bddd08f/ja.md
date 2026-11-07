```julia
start_worker([out::IO=stdout], cookie::AbstractString=readline(stdin); close_stdin::Bool=true, stderr_to_stdout::Bool=true)
```

`start_worker`は、TCP/IP経由で接続するワーカープロセスのデフォルトのエントリポイントとなる内部関数です。プロセスをJuliaクラスタのワーカーとして設定します。

host:portの情報はストリーム`out`に書き込まれます（デフォルトは標準出力です）。

必要に応じて標準入力からcookieを読み取り、空いているポート（または指定されている場合は、コマンドラインオプション`--bind-to`で指定されたポート）で待ち受け、受信したTCP接続とリクエストを処理するタスクをスケジュールします。また、オプションで標準入力を閉じ、標準エラー出力を標準出力にリダイレクトします。

この関数は戻りません。

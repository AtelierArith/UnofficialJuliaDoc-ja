```julia
start_worker([out::IO=stdout], cookie::AbstractString=readline(stdin); close_stdin::Bool=true, stderr_to_stdout::Bool=true)
```

`start_worker` は、TCP/IP 経由で接続するワーカープロセスのデフォルトのエントリーポイントとなる内部関数です。プロセスを Julia クラスタのワーカーとして設定します。

host:port の情報は、ストリーム `out` に書き込まれます（デフォルトは標準出力です）。

必要に応じて標準入力から Cookie を読み取り、空いているポート（または指定されている場合は、コマンドラインオプション `--bind-to` で指定されたポート）で待ち受け、受信した TCP 接続とリクエストを処理するタスクをスケジュールします。また、標準入力を閉じ、標準エラー出力を標準出力にリダイレクトすることもできます（いずれも任意です）。

この関数は戻りません。

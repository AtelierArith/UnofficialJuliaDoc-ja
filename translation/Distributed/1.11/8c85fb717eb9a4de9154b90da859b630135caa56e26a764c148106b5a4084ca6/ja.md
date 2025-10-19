```julia
start_worker([out::IO=stdout], cookie::AbstractString=readline(stdin); close_stdin::Bool=true, stderr_to_stdout::Bool=true)
```

`start_worker` は、TCP/IP 経由で接続するワーカープロセスのデフォルトのエントリポイントである内部関数です。プロセスを Julia クラスターのワーカーとして設定します。

ホスト:ポート情報はストリーム `out` に書き込まれます（デフォルトは stdout です）。

この関数は、必要に応じて stdin からクッキーを読み取り、空いているポートでリッスンします（または指定された場合は `--bind-to` コマンドラインオプションのポート）し、受信した TCP 接続とリクエストを処理するタスクをスケジュールします。また、（オプションで）stdin を閉じ、stderr を stdout にリダイレクトします。

戻り値はありません。

```julia
EDITOR_CALLBACKS :: Vector{Function}
```

エディターのコールバック関数を格納したベクトルです。各関数は引数として`cmd`、`path`、`line`、`column`を受け取ります。リクエストを処理する場合はエディターを開いて`true`を返し、編集リクエストを受け付けない場合は`false`を返すことが期待されます。

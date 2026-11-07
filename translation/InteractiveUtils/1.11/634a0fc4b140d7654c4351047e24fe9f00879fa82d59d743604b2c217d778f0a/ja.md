```julia
EDITOR_CALLBACKS :: Vector{Function}
```

エディターのコールバック関数を格納したベクトルです。各関数は引数として`cmd`、`path`、`line`、`column`を受け取ります。その後、エディターを開いて要求を処理したことを示す`true`を返すか、編集要求を受け付けないことを示す`false`を返すことが期待されます。

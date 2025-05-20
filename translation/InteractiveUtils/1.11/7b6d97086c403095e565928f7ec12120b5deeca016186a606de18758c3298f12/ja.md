```
EDITOR_CALLBACKS :: Vector{Function}
```

エディタコールバック関数のベクタで、引数として `cmd`、`path`、`line` および `column` を取り、リクエストを処理したことを示すためにエディタを開いて `true` を返すか、編集リクエストを辞退するために `false` を返すことが期待されます。

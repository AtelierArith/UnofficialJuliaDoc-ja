```julia
IOContext(io::IO, context::IOContext)
```

`context`のプロパティを継承しつつ、代替の`IO`をラップする`IOContext`を作成します。

!!! note
    ラップされた`io`で明示的に設定されていない限り、`io`の`displaysize`は継承されません。これは、デフォルトで`displaysize`がIOオブジェクト自体のプロパティではなく、IOオブジェクトのライフタイム中にターミナルウィンドウのサイズが変わる可能性があるため、遅延的に推測されるからです。


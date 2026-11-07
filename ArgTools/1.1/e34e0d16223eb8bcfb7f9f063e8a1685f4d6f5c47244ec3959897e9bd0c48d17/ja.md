```julia
@arg_test arg1 arg2 ... body
```

`@arg_test` マクロは、`arg_readers` と `arg_writers` が提供する `arg` 関数を、実際の引数値に変換するために使用します。`@arg_test arg body` と記述することは、`arg(arg -> body)` と同じです。

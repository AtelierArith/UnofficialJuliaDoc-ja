```julia
@arg_test arg1 arg2 ... body
```

`@arg_test` マクロは、`arg_readers` および `arg_writers` によって提供される `arg` 関数を実際の引数値に変換するために使用されます。`@arg_test arg body` と書くと、`arg(arg -> body)` と同等です。

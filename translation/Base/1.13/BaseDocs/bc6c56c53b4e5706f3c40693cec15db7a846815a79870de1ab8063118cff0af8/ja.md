```julia
WrappedException(msg)
```

`Exception`など、別の`Exception`をラップする`LoadError`や`InitError`のような型の汎用型です。これらの例外には、例外の根本原因に関する情報が含まれます。サブタイプでは、原因となった`Exception`を格納するフィールド`error`を定義します。

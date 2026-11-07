```julia
@RCI f
```

`f`を`allowscalar(::Bool)`で上書きし、後で復元する関数を記録します。これは実験的な機能です。

この関数はパッケージのトップレベルで評価されることに注意してください。`f`の元のコードは`_restore_scalar_indexing`に保存され、`f`と同じ定義を持ちながらエラーを返す関数は`_destroy_scalar_indexing`に保存されます。

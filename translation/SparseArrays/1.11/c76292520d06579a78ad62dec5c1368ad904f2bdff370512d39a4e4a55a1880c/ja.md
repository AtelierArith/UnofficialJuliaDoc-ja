```
@RCI f
```

は、関数 `f` を上書き（および復元）するために `allowscalar(::Bool)` を記録します。これは実験的な機能です。

パッケージのトップレベルで関数が評価されることに注意してください。`f` の元のコードは `_restore_scalar_indexing` に保存され、`f` と同じ定義を持つがエラーを返す関数は `_destroy_scalar_indexing` に保存されています。

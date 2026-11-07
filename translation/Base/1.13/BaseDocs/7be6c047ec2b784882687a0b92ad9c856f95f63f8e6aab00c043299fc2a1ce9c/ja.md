```julia
InitError(mod::Symbol, error)
```

モジュールの`__init__`関数の実行中にエラーが発生しました。実際に発生したエラーは、`.error`フィールドで確認できます。

```julia
DateTime(periods::Period...)::DateTime
```

`Period` 型の各要素から `DateTime` 型を構築します。引数の順序は任意です。指定されていない DateTime の要素には、`Dates.default(period)` の値がデフォルトで使用されます。

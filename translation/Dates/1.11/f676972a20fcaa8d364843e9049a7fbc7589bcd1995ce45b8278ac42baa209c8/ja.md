```julia
DateTime(periods::Period...)::DateTime
```

`DateTime` 型の値を、`Period` 型の各要素から構築します。引数の順序は任意です。指定されていない DateTime の要素には、`Dates.default(period)` の値がデフォルトで設定されます。

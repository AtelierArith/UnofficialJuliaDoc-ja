```julia
Date(period::Period...)::Date
```

`Period` 型の各要素から `Date` 型を構築します。引数の順序は任意です。指定されていない `Date` 要素には、`Dates.default(period)` の値がデフォルトで設定されます。

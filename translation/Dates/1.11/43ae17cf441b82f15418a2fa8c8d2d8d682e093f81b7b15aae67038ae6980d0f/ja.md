```julia
Date(period::Period...)::Date
```

`Period` 型のパーツから `Date` 型を構築します。引数の順序は任意です。指定されていない `Date` パーツには、`Dates.default(period)` の値がデフォルトで設定されます。

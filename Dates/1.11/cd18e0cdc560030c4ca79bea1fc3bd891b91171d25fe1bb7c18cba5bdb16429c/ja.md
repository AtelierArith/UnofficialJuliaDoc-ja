```julia
Time(period::TimePeriod...)::Time
```

`Period` 型のパーツから `Time` 型を構築します。引数の順序は任意です。指定されていない `Time` パーツには、`Dates.default(period)` の値がデフォルトで設定されます。

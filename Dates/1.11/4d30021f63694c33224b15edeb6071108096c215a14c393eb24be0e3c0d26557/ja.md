```julia
Time(period::TimePeriod...) -> Time
```

`Period` 型の部分から `Time` 型を構築します。引数は任意の順序で指定できます。提供されていない `Time` 部分は `Dates.default(period)` の値にデフォルト設定されます。

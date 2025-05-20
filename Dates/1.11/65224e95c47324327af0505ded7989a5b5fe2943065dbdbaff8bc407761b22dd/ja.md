```
Date(period::Period...) -> Date
```

`Period` 型の部分から `Date` 型を構築します。引数は任意の順序で指定できます。提供されていない `Date` の部分は `Dates.default(period)` の値にデフォルト設定されます。

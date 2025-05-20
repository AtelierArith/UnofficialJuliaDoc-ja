```
DateTime(periods::Period...) -> DateTime
```

`Period`型の部分から`DateTime`型を構築します。引数は任意の順序で指定できます。提供されていないDateTimeの部分は`Dates.default(period)`の値にデフォルト設定されます。

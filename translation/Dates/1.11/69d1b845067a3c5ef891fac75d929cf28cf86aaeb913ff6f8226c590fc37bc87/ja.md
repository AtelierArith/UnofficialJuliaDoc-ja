```julia
Date(dt::DateTime) -> Date
```

`DateTime`を`Date`に変換します。`DateTime`の時間、分、秒、およびミリ秒の部分は切り捨てられ、年、月、日だけが構築に使用されます。

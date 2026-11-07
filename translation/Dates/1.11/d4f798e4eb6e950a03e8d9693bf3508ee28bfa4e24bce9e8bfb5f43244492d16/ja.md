```julia
Date(dt::DateTime)
```

`DateTime`を`Date`に変換します。`DateTime`の時、分、秒、ミリ秒の各部分は切り捨てられるため、構築には年、月、日の部分のみが使用されます。

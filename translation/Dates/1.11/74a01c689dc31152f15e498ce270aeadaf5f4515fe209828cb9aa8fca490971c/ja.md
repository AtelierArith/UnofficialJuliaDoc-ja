```
dt::Date + t::Time -> DateTime
```

`Date` と `Time` の加算は `DateTime` を生成します。`Time` の時間、分、秒、およびミリ秒の部分は、`Date` の年、月、日とともに使用されて新しい `DateTime` を作成します。`Time` 型の非ゼロのマイクロ秒またはナノ秒は `InexactError` を引き起こします。

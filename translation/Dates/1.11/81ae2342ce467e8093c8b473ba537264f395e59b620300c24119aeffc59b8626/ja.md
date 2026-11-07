```julia
dt::Date + t::Time -> DateTime
```

`Date`に`Time`を加算すると、`DateTime`が生成されます。`Time`の時、分、秒、ミリ秒の各部分と、`Date`の年、月、日の各部分を使って、新しい`DateTime`を作成します。`Time`型にゼロ以外のマイクロ秒またはナノ秒が含まれている場合、`InexactError`がスローされます。

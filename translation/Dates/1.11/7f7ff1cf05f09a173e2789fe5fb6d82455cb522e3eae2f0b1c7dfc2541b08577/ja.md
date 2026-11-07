```julia
DateLocale(["January", "February",...], ["Jan", "Feb",...],
           ["Monday", "Tuesday",...], ["Mon", "Tue",...])
```

テキスト形式の月名を解析または出力するためのロケールを作成します。

引数:

  * `months::Vector`: 12か月分の月名
  * `months_abbr::Vector`: 12か月分の月名の略称
  * `days_of_week::Vector`: 7曜日
  * `days_of_week_abbr::Vector`: 7曜日の略称

このオブジェクトは、各 `AbstractDateToken` 型に対して定義された `tryparsenext` メソッドおよび `format` メソッドの最後の引数として渡されます。

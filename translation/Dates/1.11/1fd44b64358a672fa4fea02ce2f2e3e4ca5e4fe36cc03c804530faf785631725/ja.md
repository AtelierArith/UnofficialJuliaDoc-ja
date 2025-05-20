```
DateLocale(["1月", "2月",...], ["1月", "2月",...],
           ["月曜日", "火曜日",...], ["月", "火",...])
```

テキストの月名を解析または印刷するためのロケールを作成します。

引数:

  * `months::Vector`: 12の月名
  * `months_abbr::Vector`: 12の省略形の月名
  * `days_of_week::Vector`: 7の曜日
  * `days_of_week_abbr::Vector`: 7の曜日の省略形

このオブジェクトは、各 `AbstractDateToken` タイプに対して定義された `tryparsenext` および `format` メソッドの最後の引数として渡されます。

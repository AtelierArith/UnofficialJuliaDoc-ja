```julia
DatePeriod
Year
Quarter
Month
Week
Day
```

1日以上の時間間隔。`DatePeriod`同士の一般的な比較がすべて有効とは限りません（例：`Week(1) == Day(7)`は有効ですが、`Year(1) != Day(365)`は有効ではありません）。

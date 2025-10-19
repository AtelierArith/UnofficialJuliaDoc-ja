```julia
TimePeriod
Hour
Minute
Second
Millisecond
Microsecond
Nanosecond
```

1日未満の時間の間隔。すべての`TimePeriod`間の変換が許可されています。（例：`Hour(1) == Minute(60) == Second(3600)`）

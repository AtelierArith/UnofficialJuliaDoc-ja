```julia
TimePeriod
Hour
Minute
Second
Millisecond
Microsecond
Nanosecond
```

1日未満の時間間隔。すべての`TimePeriod`間で変換できます（例：`Hour(1) == Minute(60) == Second(3600)`）。

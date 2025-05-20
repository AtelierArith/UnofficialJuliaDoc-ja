```
tonext(dt::TimeType, dow::Int; same::Bool=false) -> TimeType
```

`dt`を`dow`に対応する次の曜日に調整します。`1 = 月曜日、2 = 火曜日、など`。`same=true`を設定すると、現在の`dt`を次の`dow`として考慮でき、調整が行われないようになります。

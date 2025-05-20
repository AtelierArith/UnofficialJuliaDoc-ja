```
toprev(dt::TimeType, dow::Int; same::Bool=false) -> TimeType
```

`dt`を`dow`に対応する前の曜日に調整します。`1 = 月曜日、2 = 火曜日、など`。`same=true`を設定すると、現在の`dt`を前の`dow`として考慮し、調整が行われないようにします。

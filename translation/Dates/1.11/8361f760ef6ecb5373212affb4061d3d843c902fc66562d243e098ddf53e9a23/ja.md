```julia
tonext(dt::TimeType, dow::Int; same::Bool=false)::TimeType
```

`dt`を、`1 = Monday, 2 = Tuesday, etc`を基準として、`dow`に該当する次の曜日に調整します。`same=true`を設定すると、現在の`dt`を次の`dow`とみなせるため、調整が行われない場合があります。

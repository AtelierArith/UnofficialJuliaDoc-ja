```julia
tonext(dt::TimeType, dow::Int; same::Bool=false)::TimeType
```

`dow`に対応する次の曜日に、`1 = Monday, 2 = Tuesday, etc`を加えて`dt`を調整します。`same=true`を設定すると、現在の`dt`を次の`dow`とみなせるため、調整は行われません。

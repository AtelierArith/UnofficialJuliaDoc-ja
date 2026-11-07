```julia
toprev(dt::TimeType, dow::Int; same::Bool=false)::TimeType
```

`dow`に対応する曜日のうち、`1 = Monday, 2 = Tuesday, etc`を基準に前の日へ`dt`を調整します。`same=true`を設定すると、現在の`dt`を前の`dow`とみなせるため、調整が行われない場合があります。

```julia
toprev(dt::TimeType, dow::Int; same::Bool=false)::TimeType
```

`dt`を、`1 = Monday, 2 = Tuesday, etc`を指定して、`dow`に対応する直前の曜日に調整します。`same=true`を設定すると、現在の`dt`を直前の`dow`とみなせるため、調整が行われない場合があります。
